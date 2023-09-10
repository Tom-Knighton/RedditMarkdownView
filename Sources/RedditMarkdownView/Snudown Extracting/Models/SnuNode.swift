//
//  File.swift
//  
//
//  Created by Tom Knighton on 09/09/2023.
//

import Foundation

class SnuNode: Identifiable {
    var children: [SnuNode]
    let id: UUID = UUID()
    
    init(children: [SnuNode]) {
        self.children = children
    }
}
