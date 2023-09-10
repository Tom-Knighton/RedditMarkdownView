import XCTest
@testable import RedditMarkdownView
@testable import snudown


final class SnudownExtractorTests: XCTestCase {
    
    func testP_SpoilerWithDeepBoldEmDel_Bold_DelBold() throws {
        
        let snudownText = "<p>hey! l2<span class=\"md-spoiler-text\">Spoiler :)<strong><del><em>testing</em></del></strong></span> <strong>hey</strong> <del><strong>test</strong></del></p>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        let paragraph = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph.children.count == 6)
        
        // 1
        let child1 = try XCTUnwrap(paragraph.children[0])
        XCTAssert(child1 is SnuTextNode)
        let text = child1 as! SnuTextNode
        XCTAssert(text.insideText == "hey! l2")
        XCTAssert(text.children.isEmpty)
        
        // 2
        let child2 = try XCTUnwrap(paragraph.children[1])
        XCTAssert(child2 is SnuSpoilerNode)
        let spoiler = child2 as! SnuSpoilerNode
        XCTAssert(spoiler.insideText == "")
        XCTAssert(spoiler.children.count == 2)
    }
    
    func testP() throws {
        
        let snudownText = "<p>hey! I'm some text</p>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        let paragraph = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph.children.count == 1)
        
        // 1
        let child1 = try XCTUnwrap(paragraph.children[0])
        XCTAssert(child1 is SnuTextNode)
        let text = child1 as! SnuTextNode
        XCTAssert(text.insideText == "hey! I'm some text")
        XCTAssert(text.children.isEmpty)

    }
    
    func testA() throws {
        let snudownText = "<p><a href=\"https://reddit.com\">homepage of the internet</a></p>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        let paragraph = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph.children.count == 1)
        
        // 1
        let child1 = try XCTUnwrap(paragraph.children[0])
        XCTAssert(child1 is SnuLinkNode)
        let link = child1 as! SnuLinkNode
        XCTAssert(link.linkHref == "https://reddit.com")
        XCTAssert(link.children.count == 1)
        XCTAssert(link.children.first is SnuTextNode)
        XCTAssert((link.children.first as! SnuTextNode).insideText == "homepage of the internet")
    }
    
    func testADeep() throws {
        let snudownText = "<p><a href=\"https://reddit.com\"><strong>homepage of the internet</strong></a></p>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        let paragraph = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph.children.count == 1)
        
        // 1
        let child1 = try XCTUnwrap(paragraph.children[0])
        XCTAssert(child1 is SnuLinkNode)
        let link = child1 as! SnuLinkNode
        XCTAssert(link.linkHref == "https://reddit.com")
        XCTAssert(link.children.count == 1)
        XCTAssert(link.children.first is SnuTextNode)
        XCTAssert((link.children.first as! SnuTextNode).insideText == "homepage of the internet")
        XCTAssert((link.children.first as! SnuTextNode).decoration == .bold)
    }
    
    func test_codeInline() throws {
        let snudownText = "<p><code>let x = 1</code></p>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        let paragraph = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph.children.count == 1)
        
        // 1
        let child1 = try XCTUnwrap(paragraph.children[0])
        XCTAssert(child1 is SnuCodeBlock)
        let code = child1 as! SnuCodeBlock
        XCTAssert(code.insideText == "let x = 1")
    }
    
    func test_codeBlock() throws {
        let snudownText = "<p><code>\nlet x = 1\nlet x = 2\n</code></p>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        let paragraph = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph.children.count == 1)
        
        // 1
        let child1 = try XCTUnwrap(paragraph.children[0])
        XCTAssert(child1 is SnuCodeBlock)
        let code = child1 as! SnuCodeBlock
        XCTAssert(code.insideText == "\nlet x = 1\nlet x = 2\n")
    }
    
    func test_header() throws {
        let snudownText = "<h1>Hey</h1>\n\n<h6>Hey 6</h6>"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 2)
       
        
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        let child1 = try XCTUnwrap(paragraph1.children[0])
        XCTAssert(child1 is SnuHeaderNode)
        let h1 = child1 as! SnuHeaderNode
        XCTAssert(h1.insideText == "Hey")
        XCTAssert(h1.headingLevel == .h1)
        
        // 2
        let paragraph2 = try XCTUnwrap(paragraphs[1])
        XCTAssert(paragraph2.children.count == 1)
        let child2 = try XCTUnwrap(paragraph2.children[0])
        XCTAssert(child2 is SnuHeaderNode)
        let h6 = child2 as! SnuHeaderNode
        XCTAssert(h6.insideText == "Hey 6")
        XCTAssert(h6.headingLevel == .h6)
    }
    
    func test_header_children() throws {
        let snudownText = "<h1><strong>Hey</strong></h1>"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
       
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        let child1 = try XCTUnwrap(paragraph1.children[0])
        XCTAssert(child1 is SnuHeaderNode)
        let h1 = child1 as! SnuHeaderNode
        XCTAssert(h1.insideText == "")
        XCTAssert(h1.children.count == 1)
        XCTAssert(h1.children.first is SnuTextNode)
        XCTAssert((h1.children.first as? SnuTextNode)!.decoration == .bold)
        XCTAssert(h1.headingLevel == .h1)
    }
    
    func test_ul() throws {
        let snudownText = "<ul>\n<li>eggs</li>\n<li>milk</li>\n<li>cheese</li>\n</ul>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
       
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        
        XCTAssert(paragraph1.children.first is SnuListNode)
        let ul = paragraph1.children.first as! SnuListNode
        XCTAssert(ul.children.count == 3)
        XCTAssertFalse(ul.isOrdered)
        
        let child1 = try XCTUnwrap(ul.children[0])
        XCTAssert(child1 is SnuTextNode)
        let li1 = child1 as! SnuTextNode
        XCTAssert(li1.insideText == "eggs")
        
        let child2 = try XCTUnwrap(ul.children[1])
        XCTAssert(child2 is SnuTextNode)
        let li2 = child2 as! SnuTextNode
        XCTAssert(li2.insideText == "milk")
        
        let child3 = try XCTUnwrap(ul.children[2])
        XCTAssert(child3 is SnuTextNode)
        let li3 = child3 as! SnuTextNode
        XCTAssert(li3.insideText == "cheese")
    }
    
    func test_ol() throws {
        let snudownText = "<ol>\n<li>eggs</li>\n<li>milk</li>\n<li>cheese</li>\n</ol>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
       
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        
        XCTAssert(paragraph1.children.first is SnuListNode)
        let ol = paragraph1.children.first as! SnuListNode
        XCTAssert(ol.children.count == 3)
        XCTAssertTrue(ol.isOrdered)
        
        let child1 = try XCTUnwrap(ol.children[0])
        XCTAssert(child1 is SnuTextNode)
        let li1 = child1 as! SnuTextNode
        XCTAssert(li1.insideText == "eggs")
        
        let child2 = try XCTUnwrap(ol.children[1])
        XCTAssert(child2 is SnuTextNode)
        let li2 = child2 as! SnuTextNode
        XCTAssert(li2.insideText == "milk")
        
        let child3 = try XCTUnwrap(ol.children[2])
        XCTAssert(child3 is SnuTextNode)
        let li3 = child3 as! SnuTextNode
        XCTAssert(li3.insideText == "cheese")
    }
    
    func test_singleQuote() throws {
        let snudownText = "<blockquote>\n<p>I'm a quote</p>\n</blockquote>"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        
        let quote = try XCTUnwrap(paragraph1.children[0])
        XCTAssert(quote is SnuQuoteBlockNode)
        let li1 = quote as! SnuQuoteBlockNode
        XCTAssert(quote.children.count == 1)
        
        XCTAssert(quote.children.first is SnuTextNode)
        let child1 = quote.children.first as! SnuTextNode
        XCTAssert(child1.insideText == "I'm a quote")
    }
    
    func test_deepQuote() throws {
        let snudownText = "<blockquote><p>Im a quote</p><blockquote><p>are you?</p></blockquote></blockquote>"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        
        let quote = try XCTUnwrap(paragraph1.children[0])
        XCTAssert(quote is SnuQuoteBlockNode)
        XCTAssert(quote.children.count == 2)
        
        XCTAssert(quote.children.first is SnuTextNode)
        let child1 = quote.children.first as! SnuTextNode
        XCTAssert(child1.insideText == "Im a quote")
        
        XCTAssert(quote.children[1] is SnuQuoteBlockNode)
        let child2 = quote.children[1] as! SnuQuoteBlockNode
        XCTAssert(child2.children.count == 1)
        let child2text = (child2.children.first as! SnuTextNode).insideText
        XCTAssert(child2text == "are you?")
    }
    
    func test_basicTable() throws {
        let snudownText = "<table><thead>\n<tr>\n<th>col1</th>\n<th>col2</th>\n</tr>\n</thead><tbody>\n<tr>\n<td>1</td>\n<td>2</td>\n</tr>\n</tbody></table>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        
        XCTAssert(paragraph1.children.first is SnuTableNode)
        let table = paragraph1.children.first as! SnuTableNode
        
        XCTAssertFalse(table.headers.isEmpty)
        XCTAssertNotNil(table.children.isEmpty)
        
        XCTAssert(table.headers.allSatisfy { $0 is SnuTableHeaderNode })
        let headers = table.headers as! [SnuTableHeaderNode]
        XCTAssertEqual(headers.count, 2)
        XCTAssert(headers.first?.alignment == .left)
        XCTAssert(headers[1].alignment == .left)
        XCTAssert(headers.first?.children.count == 1)
        
        XCTAssert(table.children.allSatisfy { $0 is SnuTableRowNode })
        let rows = table.children as! [SnuTableRowNode]
        XCTAssertEqual(rows.count, 1)
        let row1 = rows.first!
        XCTAssert(row1.children.count == 2)
    }
    
    func test_alignmentTable() throws {
        let snudownText = "<table><thead>\n<tr>\n<th align=\"right\">col1</th>\n<th>col2</th>\n<th align=\"center\">col3</th>\n</tr>\n</thead><tbody>\n<tr>\n<td>1</td>\n<td></td>\n<td>3</td>\n</tr>\n</tbody></table>\n"
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        XCTAssert(paragraphs.count == 1)
        
        // 1
        let paragraph1 = try XCTUnwrap(paragraphs.first)
        XCTAssert(paragraph1.children.count == 1)
        
        XCTAssert(paragraph1.children.first is SnuTableNode)
        let table = paragraph1.children.first as! SnuTableNode
        
        XCTAssertFalse(table.headers.isEmpty)
        XCTAssertNotNil(table.children.isEmpty)
        
        XCTAssert(table.headers.allSatisfy { $0 is SnuTableHeaderNode })
        let headers = table.headers as! [SnuTableHeaderNode]
        XCTAssertEqual(headers.count, 3)
        XCTAssert(headers.first?.alignment == .right)
        XCTAssert(headers[1].alignment == .left)
        XCTAssert(headers[2].alignment == .center)
        XCTAssert(headers.first?.children.count == 1)
        
        XCTAssert(table.children.allSatisfy { $0 is SnuTableRowNode })
        let rows = table.children as! [SnuTableRowNode]
        XCTAssertEqual(rows.count, 1)
        let row1 = rows.first!
        XCTAssert(row1.children.count == 3)
    }
    
    
    func testXXX() {
        let snudownText = "<p><span class=\"md-spoiler-text\">Spoiler</span></p>\n"
        
        let paragraphs = SnudownExtractor.extract(snudown: snudownText)
        
        let x = 1
    }
}
