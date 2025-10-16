//
//  FindPhoneManager.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/10/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

//
//  FindPhoneManager.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/10/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AudioToolbox

class FindPhoneManager: NSObject {

    static let shared = FindPhoneManager()

    private var audioPlayer: AVAudioPlayer?       // 🔔Play find_phone.mp3
    private var silentPlayer: AVAudioPlayer?      // 🔇Background mute keep alive
    private var bgTask: UIBackgroundTaskIdentifier = .invalid

    private override init() {}

    // ✅ Called once in AppDelegate to initialize the silent player and start the silent loop
    func setupAudioSession() {
        DispatchQueue.main.async {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try session.setActive(true)
                print("✅ AudioSession pre-activated")

                self.startSilentAudio()  // ✅ Start silent loop, keep the conversation going
            } catch {
                print("❌ AudioSession setup failed:", error)
            }
        }
    }

    // ✅ Play a 1 second silent file and loop it for background keep alive
    private func startSilentAudio() {
        guard silentPlayer == nil else { return }

        guard let path = Bundle.main.path(forResource: "silent", ofType: "mp3") else {
            print("❌ silent_1s.mp3 not found in bundle!")
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            silentPlayer = try AVAudioPlayer(contentsOf: url)
            silentPlayer?.volume = 0.0
            silentPlayer?.numberOfLoops = -1
            silentPlayer?.prepareToPlay()
            silentPlayer?.play()
            print("✅ Silent audio started (session keep-alive)")
        } catch {
            print("❌ Failed to start silent audio:", error)
        }
    }

    /// ✅ Reactivate the session in the background (just in case)
    func reactivateAudioSessionForBackground() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            print("✅ Background AudioSession reactivated")
        } catch {
            print("❌ Failed to reactivate session in background:", error)
        }
    }

    /// ✅Play Find Phone Ringtone
    func playRing(seconds: Int = 5) {
        reactivateAudioSessionForBackground()
        startBGTask()

        guard let path = Bundle.main.path(forResource: "find_phone", ofType: "mp3") else {
            print("❌ Could not find find_phone.mp3 in bundle")
            endBGTask()
            return
        }
        let url = URL(fileURLWithPath: path)

        if audioPlayer == nil {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = 1.0
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
            } catch {
                print("❌ Failed to create AVAudioPlayer:", error)
                endBGTask()
                return
            }
        }

        if let player = audioPlayer, !player.isPlaying {
            player.play()
            vibrateOnce()
            print("✅ Ringtone started")

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) { [weak self] in
                guard let self = self else { return }
                if self.audioPlayer?.isPlaying == true {
                    self.stopRing()
                }
            }
        }
    }
    /// ✅ stop ringtone
    func stopRing() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
        audioPlayer = nil
        endBGTask()
        print("🛑 Ringtone stopped")
    }

    private func startBGTask() {
        bgTask = UIApplication.shared.beginBackgroundTask(withName: "findphone") { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.bgTask)
            self.bgTask = .invalid
        }
    }

    private func endBGTask() {
        if bgTask != .invalid {
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
        }
    }

    private func vibrateOnce() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
