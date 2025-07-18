//
//  MarkdownView.swift
//
//
//  Created by Tom Knighton on 08/09/2023.
//

import Foundation
import SwiftUI

public struct SnudownView: View {
    @Environment(\.snuMaxCharacters) private var maxCharacters
    
    private var components: [SnuParagprah] = []
    
    public init(text: String) {
        self.components = SnudownParser.parseText(text)
    }
    
    public var body: some View {
        SnudownRenderer(paragraphs: (maxCharacters ?? 0) > 0 ? SnudownTruncator.truncateToMaxCharacters(paragraphs: components, maxCharacters: (maxCharacters ?? 0)) : components)
    }
}

#Preview {
    ScrollView {
        SnudownView(text: "#Heading 1\nRedditMarkdownView is a library to automatically handle Reddit's flavour of Markdown (Snudown) and present it in SwiftUI.\nIt can handle:\n\n- lists\n  - layered lists\n\n1. numbered lists\n\nautomatic u/Usernamelinks and /R/subredditlinks\n\nAnd even >!spoilers!< (spoilers)\n\nIt also picks up on links automatically like https://reddit.com\n\n|Column 1|Column 2|\n|-|-:|\n|It even handles tables|with alignment support|\n\nAs well as normal markdown features like **bold** text, *italic*, ~~Strikethrough~~ and all ***~~three combined~~*** :)\n\nAnd just for fun it can handle code blocks too:\n```swift\nlet x = 1\nprint(x)```\n\n")
    }
    .padding(.horizontal, 8)
    .background { Color(uiColor: .tertiarySystemBackground).ignoresSafeArea() }
}
