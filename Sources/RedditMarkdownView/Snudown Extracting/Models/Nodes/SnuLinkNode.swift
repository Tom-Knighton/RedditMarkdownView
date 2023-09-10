//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

class SnuLinkNode: SnuNode {   
    var linkHref: String
    
    init(linkHref: String, children: [SnuNode]) {
        self.linkHref = linkHref
        super.init(children: children)
    }
}
