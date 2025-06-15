//
//  ActionButton.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: 110, height: 44)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}
