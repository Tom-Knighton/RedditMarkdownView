//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownHeaderView: View {
    
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
        }
    }
    
    private func getFontForLevel() -> Font {
        switch node.headingLevel {
        case .h1:
            return Font.system(size: 34)
        case .h2:
            return Font.system(size: 30)
        case .h3:
            return Font.custom("SFUI-Regular", size: 28, relativeTo: .largeTitle)
        case .h4:
            return Font.custom("SFUI-Regular", size: 26, relativeTo: .largeTitle)
        case .h5:
            return Font.custom("SFUI-Regular", size: 24, relativeTo: .largeTitle)
        case .h6:
            return Font.custom("SFUI-Regular", size: 20, relativeTo: .largeTitle)
        }
    }
}
