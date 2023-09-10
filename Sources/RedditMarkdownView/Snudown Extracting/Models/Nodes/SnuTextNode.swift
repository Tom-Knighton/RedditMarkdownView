//
//  SnuTextNode.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

enum SnuTextNodeDecoration {
    case bold
    case strikethrough
    case italic
}

class SnuTextNode: SnuNode {

    var insideText: String    
    var decoration: SnuTextNodeDecoration?
    
    init(insideText: String, decoration: SnuTextNodeDecoration? = nil, children: [SnuNode]) {
        self.insideText = insideText
        self.decoration = decoration
        super.init(children: children)
    }
}
