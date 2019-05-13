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
        static let complexHTML = "<p><div><randomtext>Message</randomtext></div></p>"
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
                    self.testAttributedStringContainsImage(output!)
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
                    let results = self.richTextParser.generateAttributedStringArray(from: components)
                    let attributedStrings = results.output

                    expect(attributedStrings.count).to(equal(3))
                    expect(attributedStrings[1].string).to(equal("More Text"))
                    self.testAttributedStringContainsImage(attributedStrings[0])
                    self.testAttributedStringContainsImage(attributedStrings[2])
                }
                it("generates an attributed string array with the correct components for html") {
                    let components = self.richTextParser.seperateComponents(from: MarkDownText.complexHTML)
                    let results = self.richTextParser.generateAttributedStringArray(from: components)
                    let attributedStrings = results.output

                    expect(attributedStrings.count).to(equal(1))
                    expect(attributedStrings[0].string).to(equal("\nMessage"))
                }
                it("generates an attributed string array with the correct components for html on a non-main thread") {
                    waitUntil { done in
                        DispatchQueue.global().async {
                            let components = self.richTextParser.seperateComponents(from: MarkDownText.complexHTML)
                            let results = self.richTextParser.generateAttributedStringArray(from: components)
                            let attributedStrings = results.output

                            expect(attributedStrings.count).to(equal(1))
                            expect(attributedStrings[0].string).to(equal("\nMessage"))
                            done()
                        }
                    }

                }
            }
            context("Rich text to attributed string") {
                it("generates a single attributed string with multiple rich text types") {
                    let regularText = self.richTextParser.richTextToAttributedString(from: MarkDownText.regularText).output
                    expect(regularText.string.range(of: "Some Text")).toNot(beNil())

                    let complexHTML = self.richTextParser.richTextToAttributedString(from: MarkDownText.complexHTML).output
                    expect(complexHTML.string.range(of: "Message")).toNot(beNil())

                    let complexLatex = self.richTextParser.richTextToAttributedString(from: MarkDownText.complexLatex).output
                    expect(complexLatex.string.range(of: "More Text")).toNot(beNil())
                }
            }
            context("Input String to Rich Data Type") {
                it("properly generates the correct views with a mix of video and non-video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "Look at this video: youtube[12345]")
                    expect(output.count).to(equal(2))
                    expect(output[0]).to(equal(RichDataType.text(
                        richText: self.richTextParser.richTextToAttributedString(from: "Look at this video: ").output,
                        font: self.richTextParser.font,
                        errors: [ParsingError]()
                    )))
                    expect(output[1]).to(equal(RichDataType.video(tag: "youtube[12345]", error: nil)))
                }
                it("properly generates the correct views with only non-video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "Look at this!")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(equal(RichDataType.text(
                        richText: self.richTextParser.richTextToAttributedString(from: "Look at this!").output,
                        font: self.richTextParser.font,
                        errors: [ParsingError]()
                    )))
                }
                it("properly generates the correct views with only video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "youtube[12345]")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(equal(RichDataType.video(tag: "youtube[12345]", error: nil)))
                }

            }
            context("Strip Code Tags") {
                it("Successfully strips code tags from input") {
                    let output = self.richTextParser.richTextToAttributedString(from: MarkDownText.codeText).output
                    expect(output.string).to(equal("print('Hello World')"))
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

            if attachment.image != nil {
                hasImage = true
            }
        }
        expect(hasImage).to(beTrue())
    }
}

extension RichDataType: Equatable {
    public static func == (lhs: RichDataType, rhs: RichDataType) -> Bool {
        switch (lhs, rhs) {
        case let (.text(left), .text(right)):
            return left.richText == right.richText
        case let (.video(left), .video(right)):
            return left.tag == right.tag
        default:
            return false
        }
    }
}
