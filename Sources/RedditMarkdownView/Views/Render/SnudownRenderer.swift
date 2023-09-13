//
//  SnudownRenderer.swift
//
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownRenderer: View {
    
    @Environment(\.snuTextAlignment) private var textAlign
    @Environment(\.snuMultilineTextAlignment) private var multiAlign
    
    let paragraphs: [SnuParagprah]
    
    var body: some View {
        VStack(alignment: textAlign.horizontal) {
            ForEach(paragraphs) { p in
                renderParagraph(p)
            }
        }
        .multilineTextAlignment(multiAlign)
    }
    
    @ViewBuilder
    func renderParagraph(_ p: SnuParagprah) -> some View {
        WrappingHStack(alignment: textAlign, horizontalSpacing: 0, verticalSpacing: 8) {
            ForEach(p.collectedNodes) { child in
                SnudownRenderSwitch(node: child)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct SnudownRenderSwitch: View {
    
    let node: SnuNode
    
    var body: some View {   
        if let node = node as? SnuSpoilerNode {
            SnudownSpoilerView(node: node)
        }
        if let node = node as? SnuHeaderNode {
            SnudownHeaderView(node: node)
        }
        if let node = node as? SnuTableNode {
            SnudownTableView(table: node)
        }
        if let node = node as? SnuQuoteBlockNode {
            SnudownQuoteView(quote: node)
        }
        if let node = node as? SnuListNode {
            SnudownListView(list: node, headingNode: node.headerNode)
        }
        if let node = node as? SnuCodeBlock {
            SnudownCodeView(code: node)
        }
        if let node = node as? SnuTextNode {
            SnudownTextView(node: node)
        }
        
    }
}

extension SnuParagprah {
    
    /// Groups sibling nodes that have the 'text' type together, so if there are two SnuTextNode siblings under a paragraph, where [0] is a link and [1]
    /// is a normal text node, they will be grouped under another SnuTextNode so that the SnuTextView body can render them inline together
    var collectedNodes: [SnuNode] {
        var nodes: [SnuNode] = []
        
        var index = 0
        while index < self.children.count {
            let nodeAtIndex = self.children[index]
            if nodeAtIndex.type == .text, let last = nodes.last, last.type == .text {
                let newChildren = [last, nodeAtIndex]
                let newParentNode = SnuTextNode(insideText: "", children: newChildren)
                nodes.removeLast()
                nodes.append(newParentNode)
            } else {
                nodes.append(nodeAtIndex)
            }
            
            index += 1
        }
        
        return nodes
    }
}
