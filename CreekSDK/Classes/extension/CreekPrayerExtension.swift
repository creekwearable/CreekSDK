import Foundation
import Flutter

extension CreekSDK {
   /// Persist settings. No location, network request or watch connection required.
   public func configurePrayer(_ configuration: CreekPrayerConfiguration,
                               success: @escaping successBase, failure: @escaping failureArgument) {
      prayerRequest("configurePrayer", input: configuration, failure: failure) { _ in success() }
   }

   /// Read saved preferences for a settings page. Defaults only when no record exists.
   public func getPrayerConfiguration(success: @escaping (CreekPrayerConfiguration) -> Void,
                                      failure: @escaping failureArgument) {
      prayerRequest("getPrayerConfiguration", arguments: nil, failure: failure) { reply in
         self.decodePrayerReply(reply, success: success, failure: failure)
      }
   }

   /// Read seven days using saved preferences. Reading does not send to the watch.
   public func getPrayerTimes(location: PrayerLocation, startDate: PrayerDate? = nil,
                             success: @escaping (CreekPrayerResult) -> Void,
                             failure: @escaping failureArgument) {
      prayerRequest("getPrayerTimes", input: PrayerReadRequest(location: location, startDate: startDate),
                    failure: failure) { reply in
         self.decodePrayerReply(reply, success: success, failure: failure)
      }
   }

   private func prayerRequest<T: Encodable>(_ method: String, input: T,
                                             failure: @escaping failureArgument,
                                             completion: @escaping (Any?) -> Void) {
      do {
         let arguments = try JSONSerialization.jsonObject(with: JSONEncoder().encode(input))
         prayerRequest(method, arguments: arguments, failure: failure, completion: completion)
      } catch {
         DispatchQueue.main.async { failure(-1, "Invalid prayer parameters: \(error.localizedDescription)") }
      }
   }

   // Uses the MethodChannel result directly, independently of legacy callback dictionaries.
   // All callbacks and channel calls run on main; late replies after timeout are ignored.
   private func prayerRequest(_ method: String, arguments: Any?, failure: @escaping failureArgument,
                              completion: @escaping (Any?) -> Void) {
      DispatchQueue.main.async {
         guard let channel = self.methodChannel else {
            failure(-1, "SDK channel is not ready. Initialize CreekSDK first.")
            return
         }
         var finished = false
         let timeout = DispatchWorkItem {
            guard !finished else { return }
            finished = true
            failure(-1, "\(method) timed out")
         }
         DispatchQueue.main.asyncAfter(deadline: .now() + 45, execute: timeout)
         channel.invokeMethod(method, arguments: arguments) { reply in
            guard !finished else { return }
            finished = true
            timeout.cancel()
            if let error = reply as? FlutterError {
               failure(Int(error.code) ?? -1, error.message ?? error.code)
            } else if let marker = reply as? NSObject, marker === FlutterMethodNotImplemented {
               failure(-1, "Prayer bridge unavailable. Update the embedded Flutter frameworks.")
            } else {
               completion(reply)
            }
         }
      }
   }

   private func decodePrayerReply<T: Decodable>(_ reply: Any?, success: (T) -> Void,
                                                 failure: failureArgument) {
      do {
         guard let value = reply else { throw PrayerBridgeError.emptyReply }
         let bytes = try JSONSerialization.data(withJSONObject: value)
         success(try JSONDecoder().decode(T.self, from: bytes))
      } catch {
         failure(-1, "Invalid prayer response: \(error.localizedDescription)")
      }
   }
}

private struct PrayerReadRequest: Encodable {
   let location: PrayerLocation
   let startDate: PrayerDate?
}
private enum PrayerBridgeError: Error { case emptyReply }
