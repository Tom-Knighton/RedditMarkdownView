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

struct SnuTextNode: SnuNode {

    var insideText: String
    var children: [SnuNode]
    
    var decoration: SnuTextNodeDecoration?
}
