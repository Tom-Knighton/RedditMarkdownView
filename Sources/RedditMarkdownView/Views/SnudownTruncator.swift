//
//  SnudownTruncator.swift
//
//  Created by Tom Knighton on 2025-07-09
//

import Foundation

// MARK: - Truncation Result
struct TruncationResult {
    let node: SnuNode?
    let charactersUsed: Int
    let wasTruncated: Bool
}

// MARK: - Node Truncator Protocol
protocol NodeTruncator {
    func truncate(_ node: SnuNode, currentCount: Int, maxCharacters: Int) -> TruncationResult
}

// MARK: - Main Truncator
struct SnudownTruncator {
    
    static func truncateToMaxCharacters(paragraphs: [SnuParagprah], maxCharacters: Int) -> [SnuParagprah] {
        var currentCount = 0
        var result: [SnuParagprah] = []
        var wasTruncated = false
        
        for paragraph in paragraphs {
            guard !wasTruncated else { break }
            
            var newChildren: [SnuNode] = []
            for node in paragraph.children {
                guard !wasTruncated else { break }
                
                let truncationResult = truncateNode(node, currentCount: currentCount, maxCharacters: maxCharacters)
                currentCount += truncationResult.charactersUsed
                wasTruncated = truncationResult.wasTruncated
                
                if let truncatedNode = truncationResult.node {
                    newChildren.append(truncatedNode)
                }
            }
            
            if !newChildren.isEmpty {
                result.append(SnuParagprah(children: newChildren))
            }
        }
        
        return result
    }
    
    // MARK: - Private Methods
    
    private static func truncateNode(_ node: SnuNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        switch node {
        case let linkNode as SnuLinkNode:
            return truncateLinkNode(linkNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let textNode as SnuTextNode:
            return truncateTextNode(textNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let listNode as SnuListNode:
            return truncateListNode(listNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let quoteNode as SnuQuoteBlockNode:
            return truncateQuoteNode(quoteNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let headerNode as SnuHeaderNode:
            return truncateHeaderNode(headerNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let codeNode as SnuCodeBlock:
            return truncateCodeNode(codeNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let spoilerNode as SnuSpoilerNode:
            return truncateSpoilerNode(spoilerNode, currentCount: currentCount, maxCharacters: maxCharacters)
        case let tableNode as SnuTableNode:
            return truncateTableNode(tableNode, currentCount: currentCount, maxCharacters: maxCharacters)
        default:
            return truncateGenericNode(node, currentCount: currentCount, maxCharacters: maxCharacters)
        }
    }
    
    // MARK: - Node-Specific Truncators
    
    private static func truncateLinkNode(_ node: SnuLinkNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let text = node.insideText
        let charsLeft = maxCharacters - currentCount
        
        if text.count > charsLeft {
            let truncatedText = String(text.prefix(charsLeft)) + "…"
            let truncatedNode = SnuLinkNode(linkHref: node.linkHref, children: [])
            truncatedNode.insideText = truncatedText
            truncatedNode.decoration = node.decoration
            
            return TruncationResult(node: truncatedNode, charactersUsed: charsLeft, wasTruncated: true)
        } else {
            let (newChildren, totalChars, wasTruncated) = truncateChildren(
                node.children,
                currentCount: currentCount + text.count,
                maxCharacters: maxCharacters
            )
            
            let newNode = SnuLinkNode(linkHref: node.linkHref, children: newChildren)
            newNode.insideText = node.insideText
            newNode.decoration = node.decoration
            
            return TruncationResult(node: newNode, charactersUsed: text.count + totalChars, wasTruncated: wasTruncated)
        }
    }
    
    private static func truncateTextNode(_ node: SnuTextNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let text = node.insideText
        let charsLeft = maxCharacters - currentCount
        
        if text.count > charsLeft {
            let truncatedText = String(text.prefix(charsLeft)) + "…"
            let truncatedNode = SnuTextNode(insideText: truncatedText, decoration: node.decoration, children: [])
            
            return TruncationResult(node: truncatedNode, charactersUsed: charsLeft, wasTruncated: true)
        } else {
            let (newChildren, totalChars, wasTruncated) = truncateChildren(
                node.children,
                currentCount: currentCount + text.count,
                maxCharacters: maxCharacters
            )
            
            let newNode = SnuTextNode(insideText: node.insideText, decoration: node.decoration, children: newChildren)
            
            return TruncationResult(node: newNode, charactersUsed: text.count + totalChars, wasTruncated: wasTruncated)
        }
    }
    
    private static func truncateListNode(_ node: SnuListNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let (newChildren, totalChars, wasTruncated) = truncateChildren(
            node.children,
            currentCount: currentCount,
            maxCharacters: maxCharacters
        )
        
        let newNode = SnuListNode(isOrdered: node.isOrdered, children: newChildren, headerNode: node.headerNode)
        
        return TruncationResult(node: newNode, charactersUsed: totalChars, wasTruncated: wasTruncated)
    }
    
    private static func truncateQuoteNode(_ node: SnuQuoteBlockNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let (newChildren, totalChars, wasTruncated) = truncateChildren(
            node.children,
            currentCount: currentCount,
            maxCharacters: maxCharacters
        )
        
        let newNode = SnuQuoteBlockNode(children: newChildren)
        
        return TruncationResult(node: newNode, charactersUsed: totalChars, wasTruncated: wasTruncated)
    }
    
    private static func truncateHeaderNode(_ node: SnuHeaderNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let text = node.insideText
        let charsLeft = maxCharacters - currentCount
        
        if text.count > charsLeft {
            let truncatedText = String(text.prefix(charsLeft)) + "…"
            let truncatedNode = SnuHeaderNode(insideText: truncatedText, headingLevel: node.headingLevel, children: [])
            
            return TruncationResult(node: truncatedNode, charactersUsed: charsLeft, wasTruncated: true)
        } else {
            let (newChildren, totalChars, wasTruncated) = truncateChildren(
                node.children,
                currentCount: currentCount + text.count,
                maxCharacters: maxCharacters
            )
            
            let newNode = SnuHeaderNode(insideText: node.insideText, headingLevel: node.headingLevel, children: newChildren)
            
            return TruncationResult(node: newNode, charactersUsed: text.count + totalChars, wasTruncated: wasTruncated)
        }
    }
    
    private static func truncateCodeNode(_ node: SnuCodeBlock, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let text = node.insideText
        let charsLeft = maxCharacters - currentCount
        
        if text.count > charsLeft {
            let truncatedText = String(text.prefix(charsLeft)) + "…"
            let truncatedNode = SnuCodeBlock(children: [], insideText: truncatedText)
            
            return TruncationResult(node: truncatedNode, charactersUsed: charsLeft, wasTruncated: true)
        } else {
            return TruncationResult(node: node, charactersUsed: text.count, wasTruncated: false)
        }
    }
    
    private static func truncateSpoilerNode(_ node: SnuSpoilerNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let text = node.insideText
        let charsLeft = maxCharacters - currentCount
        
        if text.count > charsLeft {
            let truncatedText = String(text.prefix(charsLeft)) + "…"
            let truncatedNode = SnuSpoilerNode(insideText: truncatedText, children: [])
            
            return TruncationResult(node: truncatedNode, charactersUsed: charsLeft, wasTruncated: true)
        } else {
            let (newChildren, totalChars, wasTruncated) = truncateChildren(
                node.children,
                currentCount: currentCount + text.count,
                maxCharacters: maxCharacters
            )
            
            let newNode = SnuSpoilerNode(insideText: node.insideText, children: newChildren)
            
            return TruncationResult(node: newNode, charactersUsed: text.count + totalChars, wasTruncated: wasTruncated)
        }
    }
    
    private static func truncateTableNode(_ node: SnuTableNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let (newChildren, totalChars, wasTruncated) = truncateChildren(
            node.children,
            currentCount: currentCount,
            maxCharacters: maxCharacters
        )
        
        let newNode = SnuTableNode(headers: node.headers, children: newChildren)
        
        return TruncationResult(node: newNode, charactersUsed: totalChars, wasTruncated: wasTruncated)
    }
    
    private static func truncateGenericNode(_ node: SnuNode, currentCount: Int, maxCharacters: Int) -> TruncationResult {
        let (newChildren, totalChars, wasTruncated) = truncateChildren(
            node.children,
            currentCount: currentCount,
            maxCharacters: maxCharacters
        )
        
        let newNode = createGenericNode(from: node, with: newChildren)
        
        return TruncationResult(node: newNode, charactersUsed: totalChars, wasTruncated: wasTruncated)
    }
    
    // MARK: - Helper Methods
    
    private static func truncateChildren(_ children: [SnuNode], currentCount: Int, maxCharacters: Int) -> ([SnuNode], Int, Bool) {
        var newChildren: [SnuNode] = []
        var totalChars = 0
        var wasTruncated = false
        
        for child in children {
            let result = truncateNode(child, currentCount: currentCount + totalChars, maxCharacters: maxCharacters)
            
            if let truncatedNode = result.node {
                newChildren.append(truncatedNode)
            }
            
            totalChars += result.charactersUsed
            if result.wasTruncated {
                wasTruncated = true
                break
            }
        }
        
        return (newChildren, totalChars, wasTruncated)
    }
    
    private static func createGenericNode(from originalNode: SnuNode, with children: [SnuNode]) -> SnuNode? {
        switch originalNode {
        case is SnuQuoteBlockNode:
            return SnuQuoteBlockNode(children: children)
        case is SnuTableRowNode:
            return SnuTableRowNode(children: children)
        case is SnuTableCell:
            return SnuTableCell(children: children)
        case _ where type(of: originalNode) == SnuNode.self:
            return SnuNode(children: children)
        default:
            return nil
        }
    }
} 
