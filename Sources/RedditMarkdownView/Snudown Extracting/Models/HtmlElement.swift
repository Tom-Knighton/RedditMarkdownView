//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation
import SwiftSoup
enum HtmlType {
    case p
    case spoiler
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case a
    case bold
    case italic
    case strikethrough
    case code
    case quote
    case ul
    case ol
    case li
    case table
    case tableHead
    case tableRow
    case tableCol
    case tableBody
    case tableData
    
    
    /// Whether or not the element must be traversed down and children added instead of insideText
    func mustTraverse() -> Bool {
        switch self {
        case .a, .ul, .ol, .quote, .table, .tableHead, .tableBody, .tableRow, .tableData, .tableCol:
            return true
        default:
            return false
        }
    }
    
    private static let map: [String: HtmlType] = [
        "p": .p,
        "span": .spoiler,
        "h1": .h1,
        "h2": .h2,
        "h3": .h3,
        "h4": .h4,
        "h5": .h5,
        "h6": .h6,
        "a": .a,
        "strong": .bold,
        "del": .strikethrough,
        "em": .italic,
        "code": .code,
        "ul": .ul,
        "ol": .ol,
        "li": .li,
        "blockquote": .quote,
        "table": .table,
        "thead": .tableHead,
        "th": .tableCol,
        "tbody": .tableBody,
        "tr": .tableRow,
        "td": .tableData
    ]
    static func fromString(_ element: String) -> HtmlType? {
        if let mapped = map[element] {
            return mapped
        }
        
        return .none
    }
    
}

struct HtmlElement {
    let type: HtmlType
    let inside: String
    var children: [HtmlElement]? = nil
}

extension HtmlElement {
    static func make(_ type: HtmlType, from element: Element, children: [HtmlElement]) -> HtmlElement? {
        
        let shouldTraverse = element.children().count > 0 || type.mustTraverse()
        switch type {
        case .a:
            return HtmlElement(type: .a, inside: (try? element.attr("href")) ?? "", children: children)
        case .code:
            return HtmlElement(type: .code, inside: (try? element.text(trimAndNormaliseWhitespace: false)) ?? "", children: children)
        case .ul, .ol:
            return HtmlElement(type: type, inside: "", children: children.filter { $0.inside.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false || $0.children?.isEmpty == false})
        case .quote:
            return HtmlElement(type: .quote, inside: "", children: children.filter { $0.inside.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false || $0.children?.isEmpty == false})
        case .tableHead:
            return HtmlElement(type: .tableHead, inside: "", children: children.filter { $0.type == .tableRow })
        case .tableRow:
            return HtmlElement(type: .tableRow, inside: "", children: children.filter { $0.type == .tableCol || $0.type == .tableData })
        case .tableCol:
            return HtmlElement(type: .tableCol, inside: (try? element.attr("align")) ?? "", children: children)
        default:
            return HtmlElement(type: type, inside: shouldTraverse ? "" : element.ownText(), children: children)
        }
    }
}
