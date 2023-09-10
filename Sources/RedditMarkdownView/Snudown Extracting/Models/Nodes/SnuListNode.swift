//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

class SnuListNode: SnuNode {
    var isOrdered: Bool
    
    var headerNode: SnuNode? = nil
    
    init(isOrdered: Bool, children: [SnuNode], headerNode: SnuNode? = nil) {
        self.isOrdered = isOrdered
        self.headerNode = headerNode
        super.init(children: children)
    }
}
