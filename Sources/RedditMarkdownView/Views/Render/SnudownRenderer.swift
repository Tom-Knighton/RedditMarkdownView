//
//  SnudownRenderer.swift
//
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownRenderer: View {
    
    let paragraphs: [SnuParagprah]
    
    var body: some View {
        ForEach(paragraphs) { p in
            renderParagraph(p)
            Divider()
        }
    }
    
    @ViewBuilder
    func renderParagraph(_ p: SnuParagprah) -> some View {
        FlowLayout(verticleSpacing: 8) {
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
        if let node = node as? SnuTextNode {
            SnudownTextView(node: node)
        }
    }
}
