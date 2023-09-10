//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

class SnuListNode: SnuNode {
    var isOrdered: Bool
    
    init(isOrdered: Bool, children: [SnuNode]) {
        self.isOrdered = isOrdered
        super.init(children: children)
    }
}
