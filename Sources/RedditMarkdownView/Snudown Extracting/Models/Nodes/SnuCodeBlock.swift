//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

class SnuCodeBlock: SnuNode {
    let insideText: String
    
    init(children: [SnuNode], insideText: String) {
        self.insideText = insideText
        super.init(children: children)
    }
}
