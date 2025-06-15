//
//  PomodoroTimer.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            
            TodoView()
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
        }

    }
}
