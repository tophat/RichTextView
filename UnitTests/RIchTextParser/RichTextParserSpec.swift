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
        static let complextMarkdown = "#text **something *more words* ~(testing brackets)~"
        static let basicLatex = "[math]x^n[/math]"
        static let complextLatext = "[math]x =\\dfrac{\\dfrac{a}{b}}{c} = \\dfrac{\\frac{\\textstyle a}{\\textstyle b}}{c} = \\dfrac{\\frac{a}{b}}{c} [/math]"
    }

    var richTextParser: RichTextParser!

    override func spec() {
        describe("RichTextParser") {
            beforeEach {
                self.richTextParser = RichTextParser()
            }
            context("HTML parsing") {
                it("successfully identifies various HTML text") {
                    expect(self.richTextParser.isTextHTML(MarkDownText.standardHTML)).to(beTrue())
                    expect(self.richTextParser.isTextHTML(MarkDownText.complexHTML)).to(beTrue())
                }
                it("succssfully rejects non-markdown text") {
                    expect(self.richTextParser.isTextHTML(MarkDownText.regularText)).to(beFalse())
                    expect(self.richTextParser.isTextHTML(MarkDownText.regularTextWithFalseFlags)).to(beFalse())
                }
                it("successfully rejects markdown text") {
                    expect(self.richTextParser.isTextHTML(MarkDownText.basicMarkdown)).to(beFalse())
                    expect(self.richTextParser.isTextHTML(MarkDownText.complextMarkdown)).to(beFalse())
                }
                it("successfully rejects latex text") {
                    expect(self.richTextParser.isTextHTML(MarkDownText.basicLatex)).to(beFalse())
                    expect(self.richTextParser.isTextHTML(MarkDownText.complextLatext)).to(beFalse())
                }
            }
            context("Latex Parsing") {
                it("succesfully returns an NSAttributedString with an image") {
                    let output = self.richTextParser.extractLatex(from: MarkDownText.basicLatex)
                    expect(output).to(beAKindOf(NSAttributedString.self))
                    var hasImage = false
                    let fullRange = NSRange(location: 0, length: output.length)
                    output.enumerateAttribute(.attachment, in: fullRange, options: []) { (value, _, _) in
                        guard let attachment = value as? NSTextAttachment else { return }

                        if let _ = attachment.image {
                            hasImage = true
                        }
                    }
                    expect(hasImage).to(beTrue())
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
}
