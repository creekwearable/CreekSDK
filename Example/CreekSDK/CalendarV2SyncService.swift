//
//  CalendarV2SyncService.swift
//  CreekSDK_Example
//

import Foundation
import EventKit
import UIKit
import CreekSDK

struct CalendarV2SystemEvent {
   let id: String
   let eventIdentifier: String
   let calendarIdentifier: String
   let title: String
   let source: String
   let colorCode: String
   let start: Date
   let end: Date
   let allDay: Bool
   let recurrenceFrequency: EKRecurrenceFrequency?
   let recurrenceEnd: Date?
   let reminderMinutes: Int?
   let occurrenceOverrides: [CalendarV2OccurrenceOverride]
}

struct CalendarV2OccurrenceOverride {
   let originalStart: Date
   let newStart: Date
   let newEnd: Date
}

struct CalendarV2FirmwareSnapshot {
   let systemMax: UInt32
   let localMax: UInt32
   let batchMax: UInt32
   let items: [calendar_v2_item]
}

struct CalendarV2SyncResult {
   let systemUpserts: Int
   let systemDeletes: Int
   let firmwareUpserts: Int
   let firmwareDeletes: Int

   var totalChanges: Int {
      systemUpserts + systemDeletes + firmwareUpserts + firmwareDeletes
   }
}

/// Demo-owned EventKit integration. The SDK remains responsible only for the
/// Calendar V2 protocol; system-calendar access and conflict decisions live here.
final class CalendarV2SyncService {
   private struct Binding: Codable {
      let calendarIdentifier: String
      let eventIdentifier: String
      let firmwareSnapshot: String
   }

   private struct FirmwareApplyResult {
      let upserts: Int
      let deletes: Int
      let deleteAcks: [calendar_v2_item]
   }

   private let eventStore = EKEventStore()
   private let firmwareCalendarName = "Creek"
   private let bindingKey = "calendar_v2_firmware_bindings_ios"
   private let defaultBatchMax = 15
   private let maxFrameBytes = 3 * 1024
   private let protocolHeaderBytes = 11

   var hasCalendarAccess: Bool {
      let status = EKEventStore.authorizationStatus(for: .event)
      if #available(iOS 17.0, *) {
         return status == .fullAccess
      }
      return status == .authorized
   }

   func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
      if #available(iOS 17.0, *) {
         eventStore.requestFullAccessToEvents { granted, _ in
            DispatchQueue.main.async { completion(granted) }
         }
      } else {
         eventStore.requestAccess(to: .event) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
         }
      }
   }

   func getFirmwareSnapshot(completion: @escaping (Result<CalendarV2FirmwareSnapshot, Error>) -> Void) {
      CreekInterFace.instance.getCalendarListV2 { reply in
         let snapshot = CalendarV2FirmwareSnapshot(
            systemMax: reply.systemCalendarSupportMax,
            localMax: reply.localCalendarSupportMax,
            batchMax: reply.maxUpsertItemsPerRequest == 0 ? 15 : min(reply.maxUpsertItemsPerRequest, 15),
            items: reply.calendarItem
         )
         completion(.success(snapshot))
      } failure: { code, message in
         completion(.failure(CalendarV2DemoError.sdk("\(code): \(message)")))
      }
   }

   func getSystemEvents() throws -> [CalendarV2SystemEvent] {
      guard hasCalendarAccess else { throw CalendarV2DemoError.permissionRequired }
      let calendars = eventStore.calendars(for: .event).filter { $0.title != firmwareCalendarName }
      let now = Date()
      let rangeStart = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now
      let rangeEnd = Calendar.current.date(byAdding: .day, value: 60, to: now) ?? now
      let predicate = eventStore.predicateForEvents(withStart: rangeStart, end: rangeEnd, calendars: calendars)
      let events = eventStore.events(matching: predicate).filter { $0.endDate >= now }
      var groups: [String: [EKEvent]] = [:]
      for event in events {
         guard let eventIdentifier = event.eventIdentifier, !eventIdentifier.isEmpty else { continue }
         let calendarIdentifier = event.calendar.calendarIdentifier
         let externalIdentifier = event.calendarItemExternalIdentifier ?? ""
         let seriesIdentifier = externalIdentifier.isEmpty ? eventIdentifier : externalIdentifier
         groups["\(calendarIdentifier):\(seriesIdentifier)", default: []].append(event)
      }

      let result = groups.values.compactMap { group -> CalendarV2SystemEvent? in
         guard let event = group.sorted(by: {
            if $0.isDetached != $1.isDetached { return !$0.isDetached }
            return $0.startDate < $1.startDate
         }).first,
         let eventIdentifier = event.eventIdentifier, !eventIdentifier.isEmpty else { return nil }
         let calendarIdentifier = event.calendar.calendarIdentifier
         let id = systemId(calendarIdentifier: calendarIdentifier, eventIdentifier: eventIdentifier)
         let recurrenceFrequency = event.recurrenceRules?.first?.frequency
         let recurrenceEnd = event.recurrenceRules?.first?.recurrenceEnd?.endDate
         let reminderMinutes = event.alarms?
            .map { Int(abs($0.relativeOffset) / 60) }
            .filter { $0 > 0 }
            .min()
         var overridesByDate: [TimeInterval: CalendarV2OccurrenceOverride] = [:]
         for occurrence in group where occurrence.isDetached {
            guard let originalStart = occurrence.occurrenceDate else { continue }
            overridesByDate[originalStart.timeIntervalSince1970] = CalendarV2OccurrenceOverride(
               originalStart: originalStart,
               newStart: occurrence.startDate,
               newEnd: occurrence.endDate
            )
         }
         let overrides = overridesByDate.values.sorted { $0.originalStart < $1.originalStart }
         return CalendarV2SystemEvent(
            id: id,
            eventIdentifier: eventIdentifier,
            calendarIdentifier: calendarIdentifier,
            title: event.title ?? "",
            source: event.calendar.source.title.isEmpty ? event.calendar.title : event.calendar.source.title,
            colorCode: colorCode(event.calendar.cgColor),
            start: event.startDate,
            end: event.endDate,
            allDay: event.isAllDay,
            recurrenceFrequency: recurrenceFrequency,
            recurrenceEnd: recurrenceEnd,
            reminderMinutes: reminderMinutes,
            occurrenceOverrides: overrides
         )
      }
      return result.sorted { $0.start < $1.start }
   }

   func sync(
      selectedSystemIds: Set<String>,
      completion: @escaping (Result<CalendarV2SyncResult, Error>) -> Void
   ) {
      guard hasCalendarAccess else {
         completion(.failure(CalendarV2DemoError.permissionRequired))
         return
      }
      getFirmwareSnapshot { [weak self] result in
         guard let self = self else { return }
         switch result {
         case .failure(let error):
            completion(.failure(error))
         case .success(let snapshot):
            guard selectedSystemIds.count <= Int(snapshot.systemMax) else {
               completion(.failure(CalendarV2DemoError.limitReached(Int(snapshot.systemMax))))
               return
            }
            do {
               let firmwareResult = try self.applyFirmwareChangesToSystem(snapshot.items)
               self.sendBatches(
                  firmwareResult.deleteAcks,
                  delete: true,
                  batchMax: Int(snapshot.batchMax)
               ) { ackResult in
                  switch ackResult {
                  case .failure(let error):
                     completion(.failure(error))
                  case .success:
                     do {
                        let latestSystemEvents = try self.getSystemEvents()
                        self.applySelectedSystemEventsToFirmware(
                           snapshot: snapshot,
                           selectedIds: selectedSystemIds,
                           systemEvents: latestSystemEvents
                        ) { systemResult in
                           switch systemResult {
                           case .failure(let error):
                              completion(.failure(error))
                           case .success(let counts):
                              completion(.success(CalendarV2SyncResult(
                                 systemUpserts: counts.0,
                                 systemDeletes: counts.1,
                                 firmwareUpserts: firmwareResult.upserts,
                                 firmwareDeletes: firmwareResult.deletes
                              )))
                           }
                        }
                     } catch {
                        completion(.failure(error))
                     }
                  }
               }
            } catch {
               completion(.failure(error))
            }
         }
      }
   }

   private func applyFirmwareChangesToSystem(_ items: [calendar_v2_item]) throws -> FirmwareApplyResult {
      var bindings = loadBindings()
      var deleteAcks: [calendar_v2_item] = []
      var upsertCount = 0
      var deleteCount = 0

      for item in items where item.deleted {
         let id = itemId(item)
         guard !id.isEmpty else { continue }
         let eventIdentifier: String?
         if item.origin == .calendarOriginSystem {
            eventIdentifier = parseSystemId(id)?.1
         } else {
            eventIdentifier = (bindings[id] ?? recoverBinding(for: id))?.eventIdentifier
         }
         if let eventIdentifier = eventIdentifier,
            let event = eventStore.event(withIdentifier: eventIdentifier) {
            try eventStore.remove(event, span: .thisEvent, commit: true)
            deleteCount += 1
         }
         var ack = calendar_v2_item()
         ack.id = item.id
         ack.origin = item.origin
         deleteAcks.append(ack)
         bindings.removeValue(forKey: id)
      }

      for item in items where item.origin == .calendarOriginFirmwareLocal && !item.deleted {
         let id = itemId(item)
         guard !id.isEmpty else { continue }
         let contentSnapshot = firmwareContentSnapshot(item)
         var binding = bindings[id] ?? recoverBinding(for: id)
         let existingEvent = binding.flatMap { eventStore.event(withIdentifier: $0.eventIdentifier) }
         guard existingEvent == nil || binding?.firmwareSnapshot != contentSnapshot else { continue }

         let event = existingEvent ?? EKEvent(eventStore: eventStore)
         if existingEvent == nil { event.calendar = try firmwareCalendar() }
         fillSystemEvent(event, from: item, firmwareId: id)
         try eventStore.save(event, span: .thisEvent, commit: true)
         guard let eventIdentifier = event.eventIdentifier else {
            throw CalendarV2DemoError.systemCalendar("The created event has no identifier")
         }
         binding = Binding(
            calendarIdentifier: event.calendar.calendarIdentifier,
            eventIdentifier: eventIdentifier,
            firmwareSnapshot: contentSnapshot
         )
         bindings[id] = binding
         upsertCount += 1
      }
      saveBindings(bindings)
      return FirmwareApplyResult(upserts: upsertCount, deletes: deleteCount, deleteAcks: deleteAcks)
   }

   private func applySelectedSystemEventsToFirmware(
      snapshot: CalendarV2FirmwareSnapshot,
      selectedIds: Set<String>,
      systemEvents: [CalendarV2SystemEvent],
      completion: @escaping (Result<(Int, Int), Error>) -> Void
   ) {
      let candidates = Dictionary(uniqueKeysWithValues: systemEvents.map { ($0.id, $0) })
      let desiredIds = selectedIds.intersection(Set(candidates.keys))
      let existingItems = snapshot.items.filter {
         $0.origin == .calendarOriginSystem && !$0.deleted
      }
      let existing = Dictionary(uniqueKeysWithValues: existingItems.map { (itemId($0), $0) })

      let deletes = Set(existing.keys).subtracting(desiredIds).map { id -> calendar_v2_item in
         var item = calendar_v2_item()
         item.id = Data(id.utf8)
         item.origin = .calendarOriginSystem
         return item
      }
      let upserts = desiredIds.compactMap { id -> calendar_v2_item? in
         guard let event = candidates[id] else { return nil }
         let next = protocolItem(event)
         guard let current = existing[id] else { return next }
         return sameCalendarContent(current, next) ? nil : next
      }.sorted { itemDate($0) < itemDate($1) }

      sendBatches(deletes, delete: true, batchMax: Int(snapshot.batchMax)) { [weak self] deleteResult in
         guard let self = self else { return }
         switch deleteResult {
         case .failure(let error):
            completion(.failure(error))
         case .success:
            self.sendBatches(upserts, delete: false, batchMax: Int(snapshot.batchMax)) { upsertResult in
               switch upsertResult {
               case .failure(let error): completion(.failure(error))
               case .success: completion(.success((upserts.count, deletes.count)))
               }
            }
         }
      }
   }

   private func sendBatches(
      _ items: [calendar_v2_item],
      delete: Bool,
      batchMax: Int,
      completion: @escaping (Result<Void, Error>) -> Void
   ) {
      do {
         let batches = try buildBatches(items, delete: delete, batchMax: batchMax)
         sendBatch(batches, index: 0, delete: delete, completion: completion)
      } catch {
         completion(.failure(error))
      }
   }

   private func sendBatch(
      _ batches: [[calendar_v2_item]],
      index: Int,
      delete: Bool,
      completion: @escaping (Result<Void, Error>) -> Void
   ) {
      guard batches.indices.contains(index) else {
         completion(.success(()))
         return
      }
      let success: successBase = { [weak self] in
         guard let self = self else { return }
         self.sendBatch(batches, index: index + 1, delete: delete, completion: completion)
      }
      let failure: failureArgument = { code, message in
         completion(.failure(CalendarV2DemoError.sdk("\(code): \(message)")))
      }
      if delete {
         CreekInterFace.instance.deleteCalendarV2(items: batches[index], success: success, failure: failure)
      } else {
         CreekInterFace.instance.upsertCalendarV2(items: batches[index], success: success, failure: failure)
      }
   }

   private func buildBatches(
      _ items: [calendar_v2_item],
      delete: Bool,
      batchMax: Int
   ) throws -> [[calendar_v2_item]] {
      let itemLimit = max(1, min(batchMax == 0 ? defaultBatchMax : batchMax, defaultBatchMax))
      var result: [[calendar_v2_item]] = []
      var current: [calendar_v2_item] = []
      for item in items {
         let candidate = current + [item]
         let exceedsCount = !delete && candidate.count > itemLimit
         if (exceedsCount || !fitsFrame(candidate, delete: delete)) && !current.isEmpty {
            result.append(current)
            current = [item]
         } else {
            current = candidate
         }
         guard fitsFrame(current, delete: delete) else { throw CalendarV2DemoError.itemTooLarge }
      }
      if !current.isEmpty { result.append(current) }
      return result
   }

   private func fitsFrame(_ items: [calendar_v2_item], delete: Bool) -> Bool {
      var operate = protocol_calendar_v2_operate()
      operate.operate = delete ? .calendarV2Delete : .calendarV2Upsert
      operate.calendarItem = items
      return ((try? operate.serializedData().count) ?? maxFrameBytes) + protocolHeaderBytes <= maxFrameBytes
   }

   private func protocolItem(_ event: CalendarV2SystemEvent) -> calendar_v2_item {
      let calendar = Calendar.current
      let start = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: event.start)
      let end = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: event.end)
      var item = calendar_v2_item()
      item.id = Data(event.id.utf8)
      item.startYear = UInt32(start.year ?? 0)
      item.startMonth = UInt32(start.month ?? 0)
      item.startDay = UInt32(start.day ?? 0)
      item.startHour = UInt32(start.hour ?? 0)
      item.startMinute = UInt32(start.minute ?? 0)
      item.endYear = UInt32(end.year ?? 0)
      item.endMonth = UInt32(end.month ?? 0)
      item.endDay = UInt32(end.day ?? 0)
      item.endHour = UInt32(end.hour ?? 0)
      item.endMinute = UInt32(end.minute ?? 0)
      item.allDay = event.allDay
      item.repeatDate = repeatDate(event.recurrenceFrequency)
      item.repeatTime = repeatTime(event.reminderMinutes)
      item.content = Data(event.title.utf8)
      item.calendarSource = Data(event.source.utf8)
      item.colorCode = Data(event.colorCode.utf8)
      item.origin = .calendarOriginSystem
      item.deleted = false
      if let repeatUntil = event.recurrenceEnd {
         let components = calendar.dateComponents([.year, .month, .day], from: repeatUntil)
         item.repeatUntilYear = UInt32(components.year ?? 0)
         item.repeatUntilMonth = UInt32(components.month ?? 0)
         item.repeatUntilDay = UInt32(components.day ?? 0)
      }
      item.overrides = event.occurrenceOverrides.map { value in
         var item = override_item()
         item.overrideStart = calendarTime(value.originalStart)
         item.overrideNewStart = calendarTime(value.newStart)
         item.overrideNewEnd = calendarTime(value.newEnd)
         return item
      }
      return item
   }

   private func fillSystemEvent(_ event: EKEvent, from item: calendar_v2_item, firmwareId: String) {
      event.title = String(decoding: item.content, as: UTF8.self)
      event.notes = "[creek-fw-id:\(firmwareId)]"
      event.startDate = itemDate(item)
      event.endDate = endDate(item)
      event.isAllDay = item.allDay
      event.recurrenceRules = recurrenceRule(item.repeatDate, endDate: repeatUntilDate(item)).map { [$0] }
      event.alarms = reminderMinutes(item.repeatTime).map { [EKAlarm(relativeOffset: -Double($0 * 60))] }
   }

   private func firmwareCalendar() throws -> EKCalendar {
      if let calendar = eventStore.calendars(for: .event).first(where: {
         $0.title == firmwareCalendarName && $0.allowsContentModifications
      }) {
         return calendar
      }
      let calendar = EKCalendar(for: .event, eventStore: eventStore)
      calendar.title = firmwareCalendarName
      calendar.source = eventStore.sources.first(where: { $0.sourceType == .local })
         ?? eventStore.defaultCalendarForNewEvents?.source
      guard calendar.source != nil else { throw CalendarV2DemoError.noWritableCalendar }
      try eventStore.saveCalendar(calendar, commit: true)
      return calendar
   }

   private func recoverBinding(for firmwareId: String) -> Binding? {
      guard let calendar = eventStore.calendars(for: .event).first(where: { $0.title == firmwareCalendarName }) else {
         return nil
      }
      let now = Date()
      let start = Calendar.current.date(byAdding: .year, value: -10, to: now) ?? now
      let end = Calendar.current.date(byAdding: .year, value: 10, to: now) ?? now
      let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: [calendar])
      guard let event = eventStore.events(matching: predicate).first(where: {
         $0.notes == "[creek-fw-id:\(firmwareId)]"
      }), let eventIdentifier = event.eventIdentifier else { return nil }
      return Binding(
         calendarIdentifier: calendar.calendarIdentifier,
         eventIdentifier: eventIdentifier,
         firmwareSnapshot: ""
      )
   }

   private func loadBindings() -> [String: Binding] {
      guard let data = UserDefaults.standard.data(forKey: bindingKey),
            let value = try? JSONDecoder().decode([String: Binding].self, from: data) else { return [:] }
      return value
   }

   private func saveBindings(_ bindings: [String: Binding]) {
      guard let data = try? JSONEncoder().encode(bindings) else { return }
      UserDefaults.standard.set(data, forKey: bindingKey)
   }

   private func systemId(calendarIdentifier: String, eventIdentifier: String) -> String {
      "sys:\(calendarIdentifier):\(eventIdentifier)"
   }

   private func parseSystemId(_ id: String) -> (String, String)? {
      guard id.hasPrefix("sys:"), let separator = id[id.index(id.startIndex, offsetBy: 4)...].firstIndex(of: ":") else {
         return nil
      }
      let calendarId = String(id[id.index(id.startIndex, offsetBy: 4)..<separator])
      let eventId = String(id[id.index(after: separator)...])
      return eventId.isEmpty ? nil : (calendarId, eventId)
   }

   private func itemId(_ item: calendar_v2_item) -> String {
      String(decoding: item.id, as: UTF8.self)
   }

   private func itemDate(_ item: calendar_v2_item) -> Date {
      Calendar.current.date(from: DateComponents(
         year: Int(item.startYear), month: Int(item.startMonth), day: Int(item.startDay),
         hour: Int(item.startHour), minute: Int(item.startMinute)
      )) ?? Date()
   }

   private func endDate(_ item: calendar_v2_item) -> Date {
      Calendar.current.date(from: DateComponents(
         year: Int(item.endYear), month: Int(item.endMonth), day: Int(item.endDay),
         hour: Int(item.endHour), minute: Int(item.endMinute)
      )) ?? itemDate(item)
   }

   private func firmwareContentSnapshot(_ item: calendar_v2_item) -> String {
      [
         item.startYear, item.startMonth, item.startDay, item.startHour, item.startMinute,
         item.endYear, item.endMonth, item.endDay, item.endHour, item.endMinute
      ].map(String.init).joined(separator: ",")
      + "|\(item.allDay)|\(item.repeatDate.rawValue)|\(item.repeatTime.rawValue)"
      + "|\(item.content.base64EncodedString())|\(item.calendarSource.base64EncodedString())"
      + "|\(item.repeatUntilYear),\(item.repeatUntilMonth),\(item.repeatUntilDay)"
      + "|\(item.overrides.map(overrideSnapshot).joined(separator: ";"))"
   }

   private func sameCalendarContent(_ lhs: calendar_v2_item, _ rhs: calendar_v2_item) -> Bool {
      lhs.startYear == rhs.startYear && lhs.startMonth == rhs.startMonth && lhs.startDay == rhs.startDay
         && lhs.startHour == rhs.startHour && lhs.startMinute == rhs.startMinute
         && lhs.endYear == rhs.endYear && lhs.endMonth == rhs.endMonth && lhs.endDay == rhs.endDay
         && lhs.endHour == rhs.endHour && lhs.endMinute == rhs.endMinute
         && lhs.allDay == rhs.allDay && lhs.repeatDate == rhs.repeatDate && lhs.repeatTime == rhs.repeatTime
         && lhs.content == rhs.content && lhs.allDayType == rhs.allDayType
         && lhs.repeatCustom == rhs.repeatCustom && lhs.customType == rhs.customType
         && lhs.calendarSource == rhs.calendarSource && lhs.colorCode == rhs.colorCode
         && lhs.focusModeUuid == rhs.focusModeUuid
         && lhs.repeatUntilYear == rhs.repeatUntilYear
         && lhs.repeatUntilMonth == rhs.repeatUntilMonth
         && lhs.repeatUntilDay == rhs.repeatUntilDay
         && lhs.overrides == rhs.overrides
   }

   private func repeatDate(_ frequency: EKRecurrenceFrequency?) -> repeat_calendar_v2_date {
      switch frequency {
      case .daily: return .repeatV2EveryDay
      case .weekly: return .repeatV2EveryWeek
      case .monthly: return .repeatV2EveryMonth
      case .yearly: return .repeatV2EveryYear
      default: return .repeatV2Null
      }
   }

   private func recurrenceRule(_ value: repeat_calendar_v2_date, endDate: Date?) -> EKRecurrenceRule? {
      let frequency: EKRecurrenceFrequency
      switch value {
      case .repeatV2EveryDay: frequency = .daily
      case .repeatV2EveryWeek: frequency = .weekly
      case .repeatV2EveryMonth: frequency = .monthly
      case .repeatV2EveryYear: frequency = .yearly
      default: return nil
      }
      return EKRecurrenceRule(
         recurrenceWith: frequency,
         interval: 1,
         end: endDate.map(EKRecurrenceEnd.init(end:))
      )
   }

   private func repeatUntilDate(_ item: calendar_v2_item) -> Date? {
      guard item.repeatUntilYear > 0, item.repeatUntilMonth > 0, item.repeatUntilDay > 0 else { return nil }
      var components = DateComponents()
      components.year = Int(item.repeatUntilYear)
      components.month = Int(item.repeatUntilMonth)
      components.day = Int(item.repeatUntilDay)
      components.hour = 23
      components.minute = 59
      components.second = 59
      guard let result = Calendar.current.date(from: components) else { return nil }
      let validated = Calendar.current.dateComponents([.year, .month, .day], from: result)
      guard validated.year == components.year,
            validated.month == components.month,
            validated.day == components.day else { return nil }
      return result
   }

   private func calendarTime(_ date: Date) -> calendar_time {
      let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
      var value = calendar_time()
      value.year = UInt32(components.year ?? 0)
      value.month = UInt32(components.month ?? 0)
      value.day = UInt32(components.day ?? 0)
      value.hour = UInt32(components.hour ?? 0)
      value.minute = UInt32(components.minute ?? 0)
      return value
   }

   private func overrideSnapshot(_ item: override_item) -> String {
      [item.overrideStart, item.overrideNewStart, item.overrideNewEnd]
         .map { "\($0.year),\($0.month),\($0.day),\($0.hour),\($0.minute)" }
         .joined(separator: "/")
   }

   private func repeatTime(_ minutes: Int?) -> repeat_calendar_v2_time {
      let value = minutes ?? 0
      if value >= 1440 { return .repeatV2Time1Day }
      if value >= 120 { return .repeatV2Time2Hour }
      if value >= 60 { return .repeatV2Time1Hour }
      if value >= 30 { return .repeatV2Time30Minutes }
      if value >= 15 { return .repeatV2Time15Minutes }
      if value >= 10 { return .repeatV2Time10Minutes }
      if value >= 5 { return .repeatV2Time5Minutes }
      return .repeatV2TimeNull
   }

   private func reminderMinutes(_ value: repeat_calendar_v2_time) -> Int? {
      switch value {
      case .repeatV2Time5Minutes: return 5
      case .repeatV2Time10Minutes: return 10
      case .repeatV2Time15Minutes: return 15
      case .repeatV2Time30Minutes: return 30
      case .repeatV2Time1Hour: return 60
      case .repeatV2Time2Hour: return 120
      case .repeatV2Time1Day: return 1440
      default: return nil
      }
   }

   private func colorCode(_ cgColor: CGColor?) -> String {
      guard let cgColor = cgColor else { return "B1B0B2" }
      let color = UIColor(cgColor: cgColor)
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      guard color.getRed(&red, green: &green, blue: &blue, alpha: nil) else { return "B1B0B2" }
      return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
   }
}

private enum CalendarV2DemoError: LocalizedError {
   case permissionRequired
   case limitReached(Int)
   case sdk(String)
   case systemCalendar(String)
   case noWritableCalendar
   case itemTooLarge

   var errorDescription: String? {
      switch self {
      case .permissionRequired: return "Calendar full access is required"
      case .limitReached(let max): return "The device supports up to \(max) system calendars"
      case .sdk(let message): return message
      case .systemCalendar(let message): return message
      case .noWritableCalendar: return "No writable system calendar is available"
      case .itemTooLarge: return "A calendar item exceeds the protocol frame limit"
      }
   }
}
