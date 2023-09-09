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

struct SnuTableNode: SnuNode {
    var children: [SnuNode]
    
    var headers: [SnuNode]
}

struct SnuTableHeaderNode: SnuNode {
    var children: [SnuNode]
    
    let alignment: TableAlignment
}

struct SnuTableRowNode: SnuNode {
    var children: [SnuNode]
}

struct SnuTableCell: SnuNode {
    var children: [SnuNode]
}

