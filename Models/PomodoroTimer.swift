//
//  PomodoroTimer.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import Foundation
import AVFoundation

class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: Int
    @Published var isRunning = false
    @Published var selectedSound: String = "None"
    @Published var sessionDuration: Int
    @Published var didComplete: Bool = false  // ✅ Signals when session ends

    private var timer: Timer?
    private var sessionStartDate: Date?
    private var focusDuration: TimeInterval = 0
    private var ambientPlayer: AVAudioPlayer?

    init() {
        let stored = UserDefaults.standard.integer(forKey: "sessionDuration")
        let defaultDuration = stored == 0 ? 25 : stored
        self.sessionDuration = defaultDuration
        self.timeRemaining = defaultDuration * 60
    }

    func start() {
        if isRunning { return }
        isRunning = true
        sessionStartDate = Date()
        playAmbientSound()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }

    func pause() {
        if isRunning {
            savePartialSession()
        }
        isRunning = false
        timer?.invalidate()
        stopAmbientSound()
    }

    func reset(minutes: Int? = nil) {
        if isRunning {
            savePartialSession()
        }
        pause()
        let duration = minutes ?? sessionDuration
        timeRemaining = duration * 60
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            complete()
        }
    }

    private func complete() {
        pause()
        storeFocusData(seconds: TimeInterval(sessionDuration * 60), completed: true)
        didComplete = true  // ✅ Notify session completion

        // Reset the flag to false after slight delay so it doesn't stay active
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.didComplete = false
        }
    }

    private func savePartialSession() {
        guard let start = sessionStartDate else { return }
        let elapsed = Date().timeIntervalSince(start)
        sessionStartDate = nil

        focusDuration += elapsed
        storeFocusData(seconds: elapsed, completed: false)
    }

    private func storeFocusData(seconds: TimeInterval, completed: Bool) {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        var allData = UserDefaults.standard.dictionary(forKey: "sessionLog") as? [String: [String: Any]] ?? [:]
        var todayData = allData[today] ?? ["focusedSeconds": 0, "completedSessions": 0]

        let prevSeconds = todayData["focusedSeconds"] as? TimeInterval ?? 0
        todayData["focusedSeconds"] = prevSeconds + seconds

        if completed {
            let prevSessions = todayData["completedSessions"] as? Int ?? 0
            todayData["completedSessions"] = prevSessions + 1
        }

        allData[today] = todayData
        UserDefaults.standard.set(allData, forKey: "sessionLog")
    }

    func playAmbientSound() {
        guard selectedSound != "None",
              let url = Bundle.main.url(forResource: selectedSound.lowercased(), withExtension: "mp3") else { return }

        ambientPlayer = try? AVAudioPlayer(contentsOf: url)
        ambientPlayer?.numberOfLoops = -1
        ambientPlayer?.play()
    }

    func stopAmbientSound() {
        ambientPlayer?.stop()
    }
}

