//
//  File.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI

struct SnudownListView: View {
    
    let list: SnuListNode
    var headingNode: SnuNode? = nil
    
    var body: some View {
        VStack {
            if let headingNode = headingNode as? SnuTextNode {
                SnudownTextView(node: headingNode)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                ForEach(Array(list.children.enumerated()), id: \.element.id) { i, listItem in
                    SnudownRenderSwitch(node: getItem(listItem, index: i))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.leading, headingNode == nil ? 0 : 16)
        }
    }
    
    private func getItem(_ originalNode: SnuNode, index: Int) -> SnuNode {
        let indicator = list.isOrdered ? "\(index + 1). " : "• "
        if let listText = originalNode as? SnuTextNode {
            var additionalChildren: [SnuNode] = []
            if listText.insideText.isEmpty {
                if listText.children.contains(where: { $0 is SnuListNode }) {
                    let sublist = listText.children.first(where: { $0 is SnuListNode}) as? SnuListNode
                    let heading = listText.children.first(where: { $0 is SnuTextNode}) as? SnuTextNode
                    var headingText = "\(indicator)\(heading?.insideText ?? "")"
                    if headingText.hasSuffix("\n") {
                        headingText = String(headingText.dropLast())
                    }
                    return SnuListNode(isOrdered: sublist?.isOrdered ?? false, children: sublist?.children ?? [], headerNode: SnuTextNode(insideText: headingText, decoration: heading?.decoration, children: []))
                }
                let listIndicator = SnuTextNode(insideText: indicator, children: [])
                additionalChildren.append(listIndicator)
                additionalChildren.append(contentsOf: listText.children)
                return SnuTextNode(insideText: "", decoration: listText.decoration, children: additionalChildren)
            } else {
                return SnuTextNode(insideText: "\(indicator)\(listText.insideText)", children: listText.children)
            }
        }
        return originalNode
    }
}
