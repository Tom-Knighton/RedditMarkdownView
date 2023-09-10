//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation
import SwiftSoup

struct SnudownExtractor {
    
    static func extract(snudown: String) -> [SnuParagprah] {
        
        do {
            let doc = try SwiftSoup.parseBodyFragment(snudown)
            doc.outputSettings(OutputSettings().prettyPrint(pretty: false))
            guard let body = doc.body() else {
                return []
            }
            
            let rawParagraphs = body.getChildNodes()
            
            var paragraphs: [SnuParagprah] = []
            
            for child in rawParagraphs {
                let html = try child.outerHtml()
                let flatChildren = extractFlatHtmlChildren(from: html)
                let children: [SnuNode] = flatChildren.compactMap { makeSnuNode(from: $0) }
                let snuParagraph = SnuParagprah(children: children)
                paragraphs.append(snuParagraph)
            }
            
            return paragraphs.filter { $0.children.isEmpty == false }

        } catch {
            return []
        }
    }
    
    
    private static func elementToNode(_ element: Element) -> HtmlElement? {
        let tagName = element.tag().getName()
        
        if let htmlType = HtmlType.fromString(tagName) {
            var children: [HtmlElement] = []
            let shouldTraverse = element.children().count > 0 || htmlType.mustTraverse()
            if shouldTraverse {
                let nodes = element.getChildNodes()
                for node in nodes {
                    if let node = node as? TextNode {
                        children.append(HtmlElement(type: .p, inside: node.getWholeText()))
                        continue
                    }
                    
                    if let node = node as? Element, let child = elementToNode(node) {
                        children.append(child)
                    }
                }
            }
            
            let node = HtmlElement.make(htmlType, from: element, children: children)
            return node
        }
        
        return nil
    }
    
    private static func extractFlatHtmlChildren(from paragraphString: String) -> [HtmlElement] {
        var children: [HtmlElement] = []
        do {
            let doc = try SwiftSoup.parseBodyFragment(paragraphString)
            if let body = doc.body(){
                for element in body.children().filter({ $0.hasText() }) {
                    if let node = elementToNode(element) {
                        children.append(node)
                    }
                }
            }
            
            if children.count == 1 && children.first?.type == .p && (children.first?.children?.count ?? 0) > 0 {
                return children.first?.children ?? children
            }
            return children
        } catch {
            return []
        }
    }
    
    private static func snuNodeChildren(_ htmlChilden: [HtmlElement]?) -> [SnuNode] {
        return htmlChilden?.compactMap { makeSnuNode(from: $0) } ?? []
    }
    
    private static func makeSnuNode(from htmlElement: HtmlElement) -> SnuNode {
        switch htmlElement.type {
        case .p:
            return SnuTextNode(insideText: htmlElement.inside, children: [])
        case .spoiler:
            return SnuSpoilerNode(insideText: htmlElement.inside, children: snuNodeChildren(htmlElement.children))
        case .bold:
            return SnuTextNode(insideText: htmlElement.inside, decoration: .bold, children: snuNodeChildren(htmlElement.children))
        case .strikethrough:
            return SnuTextNode(insideText: htmlElement.inside, decoration: .strikethrough, children: snuNodeChildren(htmlElement.children))
        case .italic:
            return SnuTextNode(insideText: htmlElement.inside, decoration: .italic, children: snuNodeChildren(htmlElement.children))
        case .a:
            return SnuLinkNode(linkHref: htmlElement.inside, children: snuNodeChildren(htmlElement.children))
        case .code:
            return SnuCodeBlock(children: [], insideText: htmlElement.inside)
        case .h1:
            return SnuHeaderNode(insideText: htmlElement.inside, headingLevel: .h1, children: snuNodeChildren(htmlElement.children))
        case .h2:
            return SnuHeaderNode(insideText: htmlElement.inside, headingLevel: .h2, children: snuNodeChildren(htmlElement.children))
        case .h3:
            return SnuHeaderNode(insideText: htmlElement.inside, headingLevel: .h3, children: snuNodeChildren(htmlElement.children))
        case .h4:
            return SnuHeaderNode(insideText: htmlElement.inside, headingLevel: .h4, children: snuNodeChildren(htmlElement.children))
        case .h5:
            return SnuHeaderNode(insideText: htmlElement.inside, headingLevel: .h5, children: snuNodeChildren(htmlElement.children))
        case .h6:
            return SnuHeaderNode(insideText: htmlElement.inside, headingLevel: .h6, children: snuNodeChildren(htmlElement.children))
        case .ul:
            return SnuListNode(isOrdered: false, children: snuNodeChildren(htmlElement.children))
        case .ol:
            return SnuListNode(isOrdered: true, children: snuNodeChildren(htmlElement.children))
        case .li:
            return SnuTextNode(insideText: htmlElement.inside, children: snuNodeChildren(htmlElement.children))
        case .quote:
            return SnuQuoteBlockNode(children: snuNodeChildren(htmlElement.children))
        case .table:
            guard let tableHead = htmlElement.children?[0],
                  let tableBody = htmlElement.children?[1],
                  let tableHeaders = tableHead.children?.first else {
                break
            }
            
            let rows = tableBody.children?.filter { $0.type == .tableRow }
            
            return SnuTableNode(headers: snuNodeChildren(tableHeaders.children), children: snuNodeChildren(rows))
        case .tableRow:
            return SnuTableRowNode(children: snuNodeChildren(htmlElement.children))
        case .tableCol:
            var align: TableAlignment = .left
            if htmlElement.inside == "right" {
                align = .right
            } else if htmlElement.inside == "center" {
                align = .center
            }
            
            return SnuTableHeaderNode(alignment: align, children: snuNodeChildren(htmlElement.children))
        case .tableData:
            return SnuTableCell(children: snuNodeChildren(htmlElement.children))
        default:
            return SnuTextNode(insideText: htmlElement.inside, children: [])
        }
        
        return SnuTextNode(insideText: "", children: [])
    }
}
