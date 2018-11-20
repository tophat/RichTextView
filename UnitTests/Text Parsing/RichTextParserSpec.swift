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
        static let complexHTML = "<p><div><randomtext>Message</randomtext></div></p>"
        static let basicMarkdown = "**More Text**"
        static let complexMarkdown = "#text **something *more words* ~(testing brackets)~"
        static let basicLatex = "[math]x^n[/math]"
        static let complexLatex = "[math]x^2[/math] **More Text** [math]x^n+5=2[/math]"
        static let codeText = "[code]print('Hello World')[/code]"
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
                it("generates an attributed string array with the correct components for latex and markdown") {
                    let components = self.richTextParser.seperateComponents(from: MarkDownText.complexLatex)
                    let attributedStrings = self.richTextParser.generateAttributedStringArray(from: components)

                    expect(attributedStrings.count).to(equal(3))
                    expect(attributedStrings[1].string).to(equal("More Text\n"))
                    self.testAttributedStringContainsImage(attributedStrings[0])
                    self.testAttributedStringContainsImage(attributedStrings[2])
                }
                it("generates an attributed string array with the correct components for html") {
                    let components = self.richTextParser.seperateComponents(from: MarkDownText.complexHTML)
                    let attributedStrings = self.richTextParser.generateAttributedStringArray(from: components)

                    expect(attributedStrings.count).to(equal(1))
                    expect(attributedStrings[0].string).to(equal("\nMessage\n\n"))
                }
            }
            context("Rich text to attributed string") {
                it("generates a single attributed string with multiple rich text types") {
                    let regularText = self.richTextParser.richTextToAttributedString(from: MarkDownText.regularText)
                    expect(regularText.string.range(of: "Some Text")).toNot(beNil())

                    let complexHTML = self.richTextParser.richTextToAttributedString(from: MarkDownText.complexHTML)
                    expect(complexHTML.string.range(of: "Message")).toNot(beNil())

                    let complexLatex = self.richTextParser.richTextToAttributedString(from: MarkDownText.complexLatex)
                    expect(complexLatex.string.range(of: "More Text")).toNot(beNil())
                }
            }
            context("Input String to Rich Data Type") {
                it("properly generates the correct views with a mix of video and non-video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "Look at this video: youtube[12345]")
                    expect(output.count).to(equal(2))
                    expect(output[0]).to(equal(RichDataType.text(richText: self.richTextParser.richTextToAttributedString(from: "Look at this video: "))))
                    expect(output[1]).to(equal(RichDataType.video(tag: "youtube[12345]")))
                }
                it("properly generates the correct views with only non-video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "Look at this!")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(equal(RichDataType.text(richText: self.richTextParser.richTextToAttributedString(from: "Look at this!"))))
                }
                it("properly generates the correct views with only video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "youtube[12345]")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(equal(RichDataType.video(tag: "youtube[12345]")))
                }

            }
            context("Strip Code Tags") {
                it("Successfully strips code tags from input") {
                    let output = self.richTextParser.richTextToAttributedString(from: MarkDownText.codeText)
                    expect(output.string).to(equal("print('Hello World')\n"))
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

extension RichDataType: Equatable {
    public static func == (lhs: RichDataType, rhs: RichDataType) -> Bool {
        switch (lhs, rhs) {
        case let (.text(a), .text(b)):
            return a == b
        case let (.video(a), .video(b)):
            return a == b
        default:
            return false
        }
    }
}

