//
//  SnudownTextView.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownTextView: View {
    
    let node: SnuTextNode
    
    var result = Text("")
    
    init(node: SnuTextNode) {
        self.node = node
    }
    
    var body: some View {
        buildTextView(for: node)
    }
    
    private func buildTextView(for node: SnuTextNode) -> Text {
        let childNodes = node.children.filter { $0 is SnuTextNode}.compactMap { $0 as? SnuTextNode }
        if childNodes.count > 0 {
            return buildChildrenTextViews(childNodes)
                .snuTextDecoration(node.decoration)
        } else {
            var textToDisplay = node.insideText
            if textToDisplay.hasSuffix("\n") {
                textToDisplay = String(textToDisplay.dropLast())
            }
            return Text(textToDisplay)
                .snuTextDecoration(node.decoration)
        }
    }
    
    private func buildChildrenTextViews(_ children: [SnuTextNode]) -> Text {
        return children.reduce(Text("")) { (result, childNode) in
            result + buildTextView(for: childNode)
                .snuTextDecoration(childNode.decoration)
        }
    }
}

extension Text {
    
    func snuTextDecoration(_ decoration: SnuTextNodeDecoration?) -> Text {
        switch decoration {
        case .bold:
            return self.bold()
        case .italic:
            return self.italic()
        case .strikethrough:
            return self.strikethrough()
        case .none:
            return self
        }
    }
}
