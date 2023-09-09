//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

enum SnuHeadingLevel {
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
}

struct SnuHeaderNode: SnuNode {
    var children: [SnuNode]
    
    var insideText: String
    var headingLevel: SnuHeadingLevel
}
