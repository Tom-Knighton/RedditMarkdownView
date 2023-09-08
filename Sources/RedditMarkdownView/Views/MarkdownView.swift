//
//  MarkdownView.swift
//
//
//  Created by Tom Knighton on 08/09/2023.
//

import Foundation
import SwiftUI
import snudown

public struct MarkdownView: View {
    
    public var markdownText: String?
    
    init(text: String) {
        self.markdownText = getMarkdownText(text)
    }
    
    public var body: some View {
        Text(markdownText ?? "No text :(")
    }
}

extension MarkdownView {
    
    func getMarkdownText(_ text: String) -> String? {
        snudown.init_renderers()
        let markdown_p0 = UnsafeMutablePointer<CChar>(mutating: NSString(string: text).utf8String)
        let result = snudown.markdownTest(markdown_p0)
        let x = String(validatingUTF8: snudown.markdownTest(markdown_p0))
        
        result?.deallocate()
        return x
    }
}


#Preview {
    MarkdownView(text: "[Box Score provided by ESPN](https://www.espn.com/college-football/game?gameId=401523994)\n\nTeam | 1 | 2 | 3 | 4 | T\n----|-|-|-|-|-|-\n[Colorado](#f/colorado)|7|10|14|14|45\n[TCU](#f/tcu)|0|14|14|14|42\n\n\n\n### Made with the /r/CFB [Game Thread Generator](https://gamethread.redditcfb.com)")
}
