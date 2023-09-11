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
            ForEach(p.children) { child in
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
