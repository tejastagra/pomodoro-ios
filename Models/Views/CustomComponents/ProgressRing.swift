//
//  ProgressRing.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct ProgressRing: View {
    var progress: Double
    var timeString: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)

            Text(timeString)
                .font(.system(size: 44, weight: .medium, design: .monospaced))
        }
    }
}
