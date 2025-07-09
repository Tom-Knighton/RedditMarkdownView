//
//  Environment+SnudownConfig.swift
//
//
//  Created by Tom Knighton on 11/09/2023.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var snuTableColumnAvgWidth: CGFloat = 250
    
    @Entry var snuTextAlignment: Alignment = .leading
    @Entry var snuMultilineTextAlignment: TextAlignment = .leading
    
    @Entry var snuDefaultFont: Font = .body
    @Entry var snuH1Font: Font = .system(size: 34)
    @Entry var snuH2Font: Font = .system(size: 30)
    @Entry var snuH3Font: Font = .system(size: 28)
    @Entry var snuH4Font: Font = .system(size: 26)
    @Entry var snuH5Font: Font = .system(size: 24)
    @Entry var snuH6Font: Font = .system(size: 20)
    
    @Entry var snuTextColour: Color = .primary
    @Entry var snuLinkColour: Color = .accentColor
    
    @Entry var snuDisplayInlineImages: Bool = true
    @Entry var snuInlineImageWidth: CGFloat = 50
    @Entry var snuInlineImageShowLink: Bool = true
    @Entry var snuMaxCharacters: Int? = nil
    @Entry var snuHideTables: Bool = false
}
