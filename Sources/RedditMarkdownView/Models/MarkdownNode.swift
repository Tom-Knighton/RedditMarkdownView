//
//  MarkdownNode.swift
//
//
//  Created by Tom Knighton on 07/09/2023.
//

import Foundation
import snudown


public func tets() {
    snudown.init_renderers()
    let message: NSString = "[Box Score provided by ESPN](http://www.espn.com/college-football/game?gameId=401523994)\n\nTeam | 1 | 2 | 3 | 4 | T\n----|-|-|-|-|-|-\n[Colorado](#f/colorado)|7|10|14|14|45\n[TCU](#f/tcu)|0|14|14|14|42\n\n\n\n### Made with the /r/CFB [Game Thread Generator](https://gamethread.redditcfb.com)"
    let markdown_p0 = UnsafeMutablePointer<CChar>(mutating: message.utf8String)
    let result = snudown.markdownTest(markdown_p0)
    let x = String(validatingUTF8: snudown.markdownTest(markdown_p0))
    
    print(x)
    result?.deallocate()
}
