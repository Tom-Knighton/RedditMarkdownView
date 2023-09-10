//
//  SnuTableNode.swift
//
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

enum TableAlignment {
    case center
    case left
    case right
}

class SnuTableNode: SnuNode {
    var headers: [SnuNode]
    
    init(headers: [SnuNode], children: [SnuNode]) {
        self.headers = headers
        super.init(children: children)
    }
}

class SnuTableHeaderNode: SnuNode {
    let alignment: TableAlignment
    
    init(alignment: TableAlignment, children: [SnuNode]) {
        self.alignment = alignment
        super.init(children: children)
    }
}

class SnuTableRowNode: SnuNode {}

class SnuTableCell: SnuNode {}

