//
//  SnudownTextView.swift
//  
//
//  Created by Tom Knighton on 10/09/2023.
//

import SwiftUI
import Nuke

struct SnudownTextView: View {
    
    @Environment(\.snuDefaultFont) var defaultFont: Font
    @Environment(\.snuTextColour) private var textColor
    @Environment(\.snuLinkColour) private var linkColor
    @Environment(\.snuDisplayInlineImages) private var displayImages
    @Environment(\.snuInlineImageWidth) private var imageWidth
    
    @State private var result: Text? = nil

    let node: SnuTextNode
    
    private var font: Font?
    
    init(node: SnuTextNode, font: Font? = nil) {
        self.node = node
        self.font = font
    }
    
    var body: some View {
        if let result {
            result
                .foregroundColor(textColor)
                .tint(linkColor)
        } else {
            ProgressView()
                .task {
                    self.result = await buildTextView(for: node)
                }
        }
    }
    
    private func buildTextView(for node: SnuTextNode) async -> Text {
        if let link = node as? SnuLinkNode {
            return await link.contentAsCMark(loadImages: displayImages, imageWidth: imageWidth)
                .font(font ?? defaultFont)
        }
        
        let childNodes = node.children.filter { $0 is SnuTextNode }.compactMap { $0 as? SnuTextNode }
        
        if childNodes.count > 0 {
            return await buildChildrenTextViews(childNodes)
                .snuTextDecoration(node.decoration, font: font ?? defaultFont)
        } else {
            var textToDisplay = node.insideText
            if textToDisplay.hasSuffix("\n") {
                textToDisplay = String(textToDisplay.dropLast())
            }
            return Text(textToDisplay)
                .snuTextDecoration(node.decoration, font: font ?? defaultFont)
        }
    }
    
    private func buildChildrenTextViews(_ children: [SnuTextNode]) async -> Text {
        return await children.asyncReduce(Text("")) { (result, childNode) in
            result + (await buildTextView(for: childNode)
                .snuTextDecoration(childNode.decoration, font: font ?? defaultFont))
        }
    }
}

extension Text {
    
    func snuTextDecoration(_ decoration: SnuTextNodeDecoration?, font: Font?) -> Text {
        var toReturn = self
        if let font {
            toReturn = toReturn.font(font)
        }
        switch decoration {
        case .bold:
            return toReturn.bold()
        case .italic:
            return toReturn.italic()
        case .strikethrough:
            return toReturn.strikethrough()
        case .none:
            return toReturn
        }
    }
}

extension SnuTextNode {
    
    func contentAsCMark(loadImages: Bool, imageWidth: CGFloat) async -> Text {
       
        var result = buildAttributedString(node: self)
        
        if let link = self as? SnuLinkNode {
            if loadImages, let linkUrl = URL(string: link.linkHref) {
                let imageTask = Task.detached(priority: .background) { [result] in
                    let request = ImageRequest(
                        url: linkUrl,
                        processors: [.resize(width: imageWidth)]
                    )
                    let imageTask = try? await ImagePipeline.shared.image(for: request)
                    if let cgImage = await imageTask?.byPreparingForDisplay() {
                        return Text(Image(uiImage: cgImage).resizable()) + Text(LocalizedStringKey("\n[\(result)](\(link.linkHref))"))
                    }
                    
                    return Text(LocalizedStringKey("[\(result)](\(link.linkHref))"))
                }
                return await imageTask.value
            }

            result = "[\(result)](\(link.linkHref))"
        }
        return Text(LocalizedStringKey(result))
    }
    
    private func buildAttributedString(node: SnuTextNode) -> String {
        var result = ""
        
        for child in node.children.compactMap({ $0 as? SnuTextNode }) {
            var childAttributed = child.insideText
            childAttributed.append(buildAttributedString(node: child))
            switch child.decoration {
            case .bold:
                result.append("**\(childAttributed)**")
            case .italic:
                result.append("*\(childAttributed)*")
            case .strikethrough:
                result.append("~~\(childAttributed)~~")
            default:
                result.append("\(childAttributed)")
            }
        }
        
        return result
    }
}

public extension Sequence {
    func asyncReduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: ((Result, Element) async throws -> Result)
    ) async rethrows -> Result {
        var result = initialResult
        for element in self {
            result = try await nextPartialResult(result, element)
        }
        return result
    }
}

