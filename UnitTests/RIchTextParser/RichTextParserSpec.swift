//
//  RichTextParserSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright (c) 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class RichTextParserSpec: QuickSpec {
    enum MarkDownText {
        static let regularText = "Some Text"
        static let regularTextWithFalseFlags = "Some \"Text\" with random >p and some <no closing tag>"
        static let standardHTML = "<p>some text</p>"
        static let complexHTML = "<p><div><randomtext>M</randomtext></div></p>"
        static let basicMarkdown = "**More Text**"
        static let complexMarkdown = "#text **something *more words* ~(testing brackets)~"
        static let basicLatex = "[math]x^n[/math]"
        static let complexLatex = "[math]x^2[/math] **More Text** [math]x^n+5=2[/math]"
    }

    var richTextParser: RichTextParser!

    override func spec() {
        describe("RichTextParser") {
            beforeEach {
                self.richTextParser = RichTextParser()
            }
            context("Latex Parsing") {
                it("succesfully returns an NSAttributedString with an image") {
                    let output = self.richTextParser.extractLatex(from: MarkDownText.basicLatex)
                    self.testAttributedStringContainsImage(output)
                }
            }
            context("Breaking up text into componenets") {
                it("seperates latex from html/markdown and maintains the order") {
                    let components = self.richTextParser.seperateComponents(from: MarkDownText.complexLatex)

                    expect(components.count).to(equal(3))
                    expect(components[0]).to(equal("[math]x^2[/math]"))
                    expect(components[1]).to(equal(" **More Text** "))
                    expect(components[2]).to(equal("[math]x^n+5=2[/math]"))
                }
                it("generates an attributed string array with the correct components") {
                    let components = self.richTextParser.seperateComponents(from: MarkDownText.complexLatex)
                    let attributedStrings = self.richTextParser.generateAttributedStringArray(from: components)

                    expect(attributedStrings.count).to(equal(3))
                    expect(attributedStrings[1].string).to(equal("More Text\n"))
                    self.testAttributedStringContainsImage(attributedStrings[0])
                    self.testAttributedStringContainsImage(attributedStrings[2])
                }
            }
            context("Memory leaks") {
                it("successfully deallocates without any retain cycles") {
                    class RichTextParserWithMemoryLeakChecking: RichTextParser {
                        var deinitCalled: (() -> Void)?
                        deinit {
                            deinitCalled?()
                        }
                    }
                    var deinitCalled = false

                    var instance: RichTextParserWithMemoryLeakChecking? = RichTextParserWithMemoryLeakChecking()
                    instance?.deinitCalled = {
                        deinitCalled = true
                    }
                    DispatchQueue.global(qos: .background).async {
                        instance = nil
                    }

                    expect(deinitCalled).toEventually(beTrue(), timeout: 5)
                }
            }
        }
    }

    private func testAttributedStringContainsImage(_ input: NSAttributedString) {
        expect(input).to(beAKindOf(NSAttributedString.self))
        var hasImage = false
        let fullRange = NSRange(location: 0, length: input.length)
        input.enumerateAttribute(.attachment, in: fullRange, options: []) { (value, _, _) in
            guard let attachment = value as? NSTextAttachment else { return }

            if let _ = attachment.image {
                hasImage = true
            }
        }
        expect(hasImage).to(beTrue())
    }
}
