//
//  View+SnudownConfig.swift
//
//
//  Created by Tom Knighton on 10/09/2023.
//

import Foundation
import SwiftUI

public extension View {
    
    /// Applies Snudown config rules to all `SnudownView`s in the view heirarchy
    /// Note it is also possible to manage rules individually through separate `.snu....` view modifiers
    /// - Parameter config: The `SnudownConfig` struct representing various config values
    func snudownConfig(_ config: SnudownConfig) -> some View {
        self
            .environment(\.snuTableColumnAvgWidth, config.averageTableColumnWidth)
            .environment(\.snuTextAlignment, config.textAlignment)
            .environment(\.snuMultilineTextAlignment, config.multilineTextAlignment)
            .environment(\.snuDefaultFont, config.textFont)
            .environment(\.snuH1Font, config.headingFont)
            .environment(\.snuH2Font, config.heading2Font)
            .environment(\.snuH3Font, config.heading3Font)
            .environment(\.snuH4Font, config.heading4Font)
            .environment(\.snuH5Font, config.heading5Font)
            .environment(\.snuH6Font, config.heading6Font)
            .environment(\.snuTextColour, config.textColor)
            .environment(\.snuLinkColour, config.linkColor)
            .environment(\.snuDisplayInlineImages, config.displayInlineImages)
            .environment(\.snuInlineImageWidth, config.inlineImageWidth)
            .environment(\.snuInlineImageShowLink, config.inlineImageShowLinks)
    }
    
    
    /// Sets the average width of a SnudownTable. This value is multiplied by the number of columns and the result is the max width of the Table.
    /// Each column may shrink if it needs less space, to give other columns more space, but the entire table will never exceed this value multiplied by number of columns
    func snudownTableAvgWidth(_ width: CGFloat) -> some View {
        environment(\.snuTableColumnAvgWidth, width)
    }
    
    /// Sets the default single line text alignment for text inside Snudown views
    func snudownTextAlignment(_ alignment: Alignment) -> some View {
        environment(\.snuTextAlignment, alignment)
    }
    
    /// Sets the multiline text alignment for text inside Snudown views
    func snudownMultilineAlignment(_ alignment: TextAlignment) -> some View {
        environment(\.snuMultilineTextAlignment, alignment)
    }
    
    /// Sets the font to use for the specified font level inside Snudown Views
    func snudownFont(for fontLevel: SnudownFontFor, _ font: Font) -> some View {
        switch fontLevel {
        case .body:
            return environment(\.snuDefaultFont, font)
        case .h1:
            return environment(\.snuH1Font, font)
        case .h2:
            return environment(\.snuH2Font, font)
        case .h3:
            return environment(\.snuH3Font, font)
        case .h4:
            return environment(\.snuH4Font, font)
        case .h5:
            return environment(\.snuH5Font, font)
        case .h6:
            return environment(\.snuH6Font, font)
        }
    }
    
    /// Sets the text color to use in Snudown Views
    func snudownTextColor(_ color: Color) -> some View {
        environment(\.snuTextColour, color)
    }
    
    /// Sets the color to use for links in Snudown Views
    func snudownLinkColor(_ color: Color) -> some View {
        environment(\.snuLinkColour, color)
    }
    
    /// Whether or not to detect if inline links are images and display them, may slow down loading link text generally
    func snudownDisplayInlineImages(_ display: Bool) -> some View {
        environment(\.snuDisplayInlineImages, display)
    }
    
    /// How wide inline images should be resized
    func snudownInlineImageWidth(_ width: CGFloat) -> some View {
        environment(\.snuInlineImageWidth, width)
    }
    
    /// Whether or not to display tappable links under linked images. If false, the image itself still will *not* be tappable to open urls
    func snudownShowInlineImageLinks(_ show: Bool) -> some View {
        environment(\.snuInlineImageShowLink, show)
    }
}

public enum SnudownFontFor {
    case body
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
}
