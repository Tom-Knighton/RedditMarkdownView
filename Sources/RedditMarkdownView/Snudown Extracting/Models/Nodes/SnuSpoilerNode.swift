//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

class SnuSpoilerNode: SnuNode {
    var insideText: String
    
    init(insideText: String, children: [SnuNode]) {
        self.insideText = insideText
        super.init(children: children)
    }
}
