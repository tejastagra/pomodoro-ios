//
//  StatsView.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct StatsView: View {
    @State private var log: [String: [String: Any]] = [:]

    var body: some View {
        NavigationView {
            List {
                ForEach(log.sorted(by: { $0.key > $1.key }), id: \.key) { date, data in
                    let focused = data["focusedSeconds"] as? TimeInterval ?? 0
                    let sessions = data["completedSessions"] as? Int ?? 0

                    VStack(alignment: .leading) {
                        Text(date).bold()
                        Text("🎯 \(formatTime(focused)) focused")
                        Text("🍅 \(sessions) completed sessions")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Focus Stats")
            .onAppear(perform: loadStats)
        }
    }

    func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let sec = Int(seconds) % 60
        return "\(minutes)m \(sec)s"
    }

    func loadStats() {
        log = UserDefaults.standard.dictionary(forKey: "sessionLog") as? [String: [String: Any]] ?? [:]
    }
}

