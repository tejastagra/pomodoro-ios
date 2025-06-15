//
//  TitleHeader.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct TitleHeader: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top)
    }
}
