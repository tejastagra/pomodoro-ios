//
//  TimerView.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timer = PomodoroTimer()
    @State private var focusMode = false
    @State private var showDNDReminder = false

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                TitleHeader(title: "TomatoTime 🍅")

                ProgressRing(progress: timerProgress, timeString: timeString)
                    .frame(width: 260, height: 260)

                // Session Duration Picker
                Picker("Duration", selection: $timer.sessionDuration) {
                    ForEach([15, 25, 50], id: \.self) { minutes in
                        Text("\(minutes) min")
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Ambient Sound Picker
                Picker("Ambient Sound", selection: $timer.selectedSound) {
                    ForEach(["None", "Rain", "Cafe", "Forest"], id: \.self) { sound in
                        Text(sound)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Focus Mode Toggle
                Toggle("Focus Mode", isOn: $focusMode)
                    .padding(.horizontal)
           

                // Action Buttons
                HStack(spacing: 30) {
                    ActionButton(
                        title: timer.isRunning ? "Pause" : "Start",
                        color: .green
                    ) {
                        timer.isRunning ? timer.pause() : timer.start()
                    }

                    ActionButton(
                        title: "Reset",
                        color: .red
                    ) {
                        timer.reset()
                    }
                }
            }
            .padding()
            .alert("Turn on Do Not Disturb", isPresented: $showDNDReminder) {
                Button("Got it", role: .cancel) {}
            } message: {
                Text("To stay fully focused, enable Do Not Disturb from Control Center.")
            }
            .onChange(of: focusMode) { _, newValue in
                if newValue {
                    showDNDReminder = true
                }
            }
            .onChange(of: timer.didComplete) { _, newValue in
                if newValue {
                    focusMode = false
                    showDNDReminder = false
                }
            }

            // Focus Mode Overlay
            if timer.isRunning && focusMode {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .overlay(
                        VStack {
                            Image(systemName: "moon.fill")
                                .font(.system(size: 40))
                                .padding(.bottom, 8)
                            Text("You're in Focus Mode")
                                .font(.headline)
                            Text("Swipe down to enable Do Not Disturb")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    )
            }
        }
    }

    var timeString: String {
        let minutes = timer.timeRemaining / 60
        let seconds = timer.timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var timerProgress: Double {
        let total = Double(timer.sessionDuration * 60)
        return (total - Double(timer.timeRemaining)) / total
    }
}

