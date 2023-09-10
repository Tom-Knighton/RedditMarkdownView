//
//  SnudownTextView.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownTextView: View {
    
    let node: SnuTextNode
    
    private var font: Font?
    
    init(node: SnuTextNode, font: Font? = nil) {
        self.node = node
        self.font = font
    }
    
    var body: some View {
        buildTextView(for: node)
    }
    
    private func buildTextView(for node: SnuTextNode) -> Text {
        let childNodes = node.children.filter { $0 is SnuTextNode}.compactMap { $0 as? SnuTextNode }
        if childNodes.count > 0 {
            return buildChildrenTextViews(childNodes)
                .snuTextDecoration(node.decoration, font: font)
        } else {
            var textToDisplay = node.insideText
            if textToDisplay.hasSuffix("\n") {
                textToDisplay = String(textToDisplay.dropLast())
            }
            return Text(textToDisplay)
                .snuTextDecoration(node.decoration, font: font)
        }
    }
    
    private func buildChildrenTextViews(_ children: [SnuTextNode]) -> Text {
        return children.reduce(Text("")) { (result, childNode) in
            result + buildTextView(for: childNode)
                .snuTextDecoration(childNode.decoration, font: font)
        }
    }
}

extension Text {
    
    func snuTextDecoration(_ decoration: SnuTextNodeDecoration?, font: Font?) -> Text {
        var toReturn = self
        if let font {
            toReturn = toReturn.font(font)
        }
        switch decoration {
        case .bold:
            return toReturn.bold()
        case .italic:
            return toReturn.italic()
        case .strikethrough:
            return toReturn.strikethrough()
        case .none:
            return toReturn
        }
    }
}
