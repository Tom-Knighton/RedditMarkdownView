//
//  SnudownParser.swift
//
//
//  Created by Tom Knighton on 08/09/2023.
//

import Foundation
import snudown

struct SnudownParser {
    
    /// Parses input text through snudown and returns parsed paragraphs/nodes
    /// - Parameter text: The input text
    /// - Returns: A HTML description of the input text
    static func parseText(_ text: String) -> [SnuParagprah] {
        snudown.init_renderers()
        let markdown_p0 = UnsafeMutablePointer<CChar>(mutating: (text as NSString).utf8String)
        let result = snudown.markdownTest(markdown_p0)
        let resultString = String(validatingUTF8: snudown.markdownTest(markdown_p0))
        
        let paragraphs = snudownToNodes(resultString ?? "")
        result?.deallocate()
        return paragraphs
    }
    
    private static func snudownToNodes(_ raw: String) -> [SnuParagprah] {
        
        let paragraphs = SnudownExtractor.extract(snudown: raw)
        return paragraphs
    }
        
}
