//
//  Environment+SnudownConfig.swift
//
//
//  Created by Tom Knighton on 11/09/2023.
//

import SwiftUI

//MARK: - Environment structs
struct SnuTableColumnAvgWidth: EnvironmentKey {
    static var defaultValue: CGFloat = 250
}

struct SnuTextAlignment: EnvironmentKey {
    static var defaultValue: Alignment = .leading
}

struct SnuMultilineTextAlignment: EnvironmentKey {
    static var defaultValue: TextAlignment = .leading
}

struct SnuTextFont: EnvironmentKey {
    static var defaultValue: Font = .body
}

struct SnuH1Font: EnvironmentKey {
    static var defaultValue: Font = Font.system(size: 34)
}

struct SnuH2Font: EnvironmentKey {
    static var defaultValue: Font = Font.system(size: 30)
}

struct SnuH3Font: EnvironmentKey {
    static var defaultValue: Font = Font.system(size: 28)
}

struct SnuH4Font: EnvironmentKey {
    static var defaultValue: Font = Font.system(size: 26)
}

struct SnuH5Font: EnvironmentKey {
    static var defaultValue: Font = Font.system(size: 24)
}

struct SnuH6Font: EnvironmentKey {
    static var defaultValue: Font = Font.system(size: 20)
}

struct SnuTextColour: EnvironmentKey {
    static var defaultValue: Color = .primary
}

struct SnuLinkColour: EnvironmentKey {
    static var defaultValue: Color = .accentColor
}

struct SnuDisplayInlineImages: EnvironmentKey {
    static var defaultValue: Bool = true
}

struct SnuInlineImageWidth: EnvironmentKey {
    static var defaultValue: CGFloat = 50
}

struct SnuInlineImageShowLink: EnvironmentKey {
    static var defaultValue: Bool = true
}

//MARK: - Environment Values

extension EnvironmentValues {
    
    var snuTableColumnAvgWidth: CGFloat {
        get { self[SnuTableColumnAvgWidth.self] }
        set { self[SnuTableColumnAvgWidth.self] = newValue }
    }
    
    var snuTextAlignment: Alignment {
        get { self[SnuTextAlignment.self] }
        set { self[SnuTextAlignment.self] = newValue }
    }
    
    var snuMultilineTextAlignment: TextAlignment {
        get { self[SnuMultilineTextAlignment.self] }
        set { self[SnuMultilineTextAlignment.self] = newValue }
    }
    
    var snuDefaultFont: Font {
        get { self[SnuTextFont.self] }
        set { self[SnuTextFont.self] = newValue }
    }
    
    var snuH1Font: Font {
        get { self[SnuH1Font.self] }
        set { self[SnuH1Font.self] = newValue }
    }
    
    var snuH2Font: Font {
        get { self[SnuH2Font.self] }
        set { self[SnuH2Font.self] = newValue }
    }
    
    var snuH3Font: Font {
        get { self[SnuH3Font.self] }
        set { self[SnuH3Font.self] = newValue }
    }
    
    var snuH4Font: Font {
        get { self[SnuH4Font.self] }
        set { self[SnuH4Font.self] = newValue }
    }
    
    var snuH5Font: Font {
        get { self[SnuH5Font.self] }
        set { self[SnuH5Font.self] = newValue }
    }
    
    var snuH6Font: Font {
        get { self[SnuH6Font.self] }
        set { self[SnuH6Font.self] = newValue }
    }
    
    var snuTextColour: Color {
        get { self[SnuTextColour.self] }
        set { self[SnuTextColour.self] = newValue }
    }
    
    var snuLinkColour: Color {
        get { self[SnuLinkColour.self] }
        set { self[SnuLinkColour.self] = newValue }
    }
    
    var snuDisplayInlineImages: Bool {
        get { self[SnuDisplayInlineImages.self] }
        set { self[SnuDisplayInlineImages.self] = newValue }
    }
    
    var snuInlineImageWidth: CGFloat {
        get { self[SnuInlineImageWidth.self] }
        set { self[SnuInlineImageWidth.self] = newValue }
    }
    
    var snuInlineImageShowLink: Bool {
        get { self[SnuInlineImageShowLink.self] }
        set { self[SnuInlineImageShowLink.self] = newValue }
    }
}
