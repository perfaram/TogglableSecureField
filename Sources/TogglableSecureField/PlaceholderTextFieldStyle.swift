//
//  PlaceholderTextFieldStyle.swift
//  
//
//  Created by pfaramaz on 14.12.21.
//

import SwiftUI

extension Text {
    func monospaced(_ useMonospace: Bool) -> Self {
        self.font(Font.system(.body, design: useMonospace ? .monospaced : .default))
    }
    
    var placeholderStyled: some View {
        self.lineLimit(1)
            .foregroundColor(Color(UIColor.placeholderText))
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}
