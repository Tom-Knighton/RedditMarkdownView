//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownHeaderView: View {
    
    @Environment(\.snuTextColour) private var textColour
    @Environment(\.snuH1Font) private var h1Font
    @Environment(\.snuH2Font) private var h2Font
    @Environment(\.snuH3Font) private var h3Font
    @Environment(\.snuH4Font) private var h4Font
    @Environment(\.snuH5Font) private var h5Font
    @Environment(\.snuH6Font) private var h6Font
    
    let node: SnuHeaderNode
    
    var body: some View {
        text()
    }
    
    @ViewBuilder
    func text() -> some View {
        let children = node.children.filter { $0 is SnuTextNode }.compactMap { $0 as? SnuTextNode }
        if children.count > 0 {
            let parent = SnuTextNode(insideText: "", children: children)
            SnudownTextView(node: parent, font: getFontForLevel())
        } else {
            Text(node.insideText)
                .font(getFontForLevel())
                .foregroundColor(textColour)
        }
    }
    
    private func getFontForLevel() -> Font {
        switch node.headingLevel {
        case .h1:
            return h1Font
        case .h2:
            return h2Font
        case .h3:
            return h3Font
        case .h4:
            return h4Font
        case .h5:
            return h5Font
        case .h6:
            return h6Font
        }
    }
}
