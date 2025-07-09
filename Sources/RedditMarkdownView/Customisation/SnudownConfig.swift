//
//  SnudownConfig.swift
//
//
//  Created by Tom Knighton on 10/09/2023.
//

import Foundation
import SwiftUI

public struct SnudownConfig {
    
    /// Acts the same way `.frame(maxWidth: .infinity, alignment: ...)` does, on all Snudown nodes that support it
    public var textAlignment: Alignment = .leading
    
    /// Acts the same way `.multlineTextAlignment(...)`  does, on all Snudown nodes that support it
    public var multilineTextAlignment: TextAlignment = .leading
    
    /// The font for default text
    public var textFont: Font = .body
    
    /// The font to use for h1 elements (the largest title)
    public var headingFont: Font = .system(size: 34)
    
    /// The font to use for h2 elements (second largest title)
    public var heading2Font: Font = .system(size: 30)
    
    /// The font to use for h3 elements
    public var heading3Font: Font = .system(size: 28)
    
    /// The font to use for h4 elements
    public var heading4Font: Font = .system(size: 26)
    
    /// The font to use for h5 elements
    public var heading5Font: Font = .system(size: 24)
    
    /// The font to use for h6 elements (the smallest title size)
    public var heading6Font: Font = .system(size: 20)
    
    /// The color to apply to text
    public var textColor: Color = .primary
    
    /// The color to apply to inline links
    public var linkColor: Color = .accentColor
    
    /// The average width of a table column. The entire table's width will be this value multiplied by the number of columns, and columns requiring less width will shrink to fit
    public var averageTableColumnWidth: CGFloat = 200
    
    /// Whether or not to detect if links are actually images and display them inline. May slow down displaying links in general. Defaults to true
    public var displayInlineImages: Bool = true
    
    /// The width to resize inline images to, if enabled
    public var inlineImageWidth: CGFloat = 50
    
    /// Whether or not the actual link should be displayed under a linked image. If false, you will not be able to tap the image to open the url
    public var inlineImageShowLinks: Bool = true

    /// The maximum number of characters to render in Snudown Views, truncating with ellipsis if exceeded
    public var maxCharacters: Int? = nil
}
