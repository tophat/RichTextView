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
        static let basicInteractiveElement = "[interactive-element id=123]This is an interactive element[/interactive-element]"
        static let complexInteractiveElement = "Look! An interactive element: [interactive-element id=123]element[/interactive-element]"
        static let highlightedElement = "[highlighted-element id=123]This is an highlighted element[/highlighted-element]"
        static let complexHighlightedElement = "Look! An highlighted element: [highlighted-element id=123]element[/highlighted-element]"
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
            context("Interactive Element") {
                it("succesfully returns an NSAttributedString with the custom link property from a basic interactive element") {
                    let output = self.richTextParser.extractInteractiveElement(from: NSAttributedString(string: MarkDownText.basicInteractiveElement))
                    let attributes: [NSAttributedString.Key: Any] = [
                        .link: "123"
                    ]
                    let expectedAttributedString = NSAttributedString(string: "This is an interactive element", attributes: attributes)
                    expect(output).to(equal(expectedAttributedString))
                }
                it("succesfully returns an NSAttributedString with the custom link property from a complex interactive element") {
                    let output = self.richTextParser.extractInteractiveElement(from: NSAttributedString(string: MarkDownText.complexInteractiveElement))
                    let attributes: [NSAttributedString.Key: Any] = [
                        .link: "123"
                    ]
                    let expectedAttributedString = NSAttributedString(string: "element", attributes: attributes)
                    expect(output).to(equal(expectedAttributedString))
                }
            }
            context("highlighted Element") {
                beforeEach {
                    self.richTextParser = RichTextParser(
                        customAdditionalAttributes: ["123": [
                            NSAttributedString.Key.backgroundColor: UIColor.lightGray,
                            NSAttributedString.Key.underlineStyle: 1
                        ]]
                    )

                }
                it("succesfully returns an NSAttributedString with the highlighted property from a basic highlighted element") {
                    let output = self.richTextParser.extractHighlightedElement(from: NSAttributedString(string: MarkDownText.highlightedElement))
                    let attributes: [NSAttributedString.Key: Any] = [
                        NSAttributedString.Key(rawValue: "highlight"): "123",
                        .backgroundColor: UIColor.lightGray,
                        .underlineStyle: 1
                    ]
                    let expectedAttributedString = NSAttributedString(string: "This is an highlighted element", attributes: attributes)
                    expect(output).to(equal(expectedAttributedString))
                }
                it("succesfully returns an NSAttributedString with the highlighted property from a complex highlighted element") {
                    let output = self.richTextParser.extractHighlightedElement(from: NSAttributedString(string: MarkDownText.complexHighlightedElement))
                    let attributes: [NSAttributedString.Key: Any] = [
                        NSAttributedString.Key(rawValue: "highlight"): "123",
                        .backgroundColor: UIColor.lightGray,
                        .underlineStyle: 1
                    ]
                    let expectedAttributedString = NSAttributedString(string: "element", attributes: attributes)
                    expect(output).to(equal(expectedAttributedString))
                }
            }
            context("Rich text to attributed string") {
                it("generates a single attributed string with multiple rich text types") {
                    let regularText = self.richTextParser.getRichTextWithErrors(from: MarkDownText.regularText).output
                    expect(regularText.string.range(of: "Some Text")).toNot(beNil())

                    let complexHTML = self.richTextParser.getRichTextWithErrors(from: MarkDownText.complexHTML).output
                    expect(complexHTML.string.range(of: "Message")).toNot(beNil())

                    let complexLatex = self.richTextParser.getRichTextWithErrors(from: MarkDownText.complexLatex).output
                    expect(complexLatex.string.range(of: "More Text")).toNot(beNil())
                }
                it("generates a single attributed string with multiple rich text types on a background thread") {
                    waitUntil { done in
                        DispatchQueue.global().async {
                            let regularText = self.richTextParser.getRichTextWithErrors(from: MarkDownText.regularText).output
                            expect(regularText.string.range(of: "Some Text")).toNot(beNil())

                            let complexHTML = self.richTextParser.getRichTextWithErrors(from: MarkDownText.complexHTML).output
                            expect(complexHTML.string.range(of: "Message")).toNot(beNil())

                            let complexLatex = self.richTextParser.getRichTextWithErrors(from: MarkDownText.complexLatex).output
                            expect(complexLatex.string.range(of: "More Text")).toNot(beNil())
                            done()
                        }
                    }
                }
            }
            context("Input String to Rich Data Type") {
                it("properly generates the correct views with a mix of video and non-video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "Look at this video: youtube[12345]")
                    expect(output.count).to(equal(2))
                    expect(output[0]).to(equal(RichDataType.text(
                        richText: self.richTextParser.getRichTextWithErrors(from: "Look at this video: ").output,
                        font: self.richTextParser.font,
                        errors: [ParsingError]()
                    )))
                    expect(output[1]).to(equal(RichDataType.video(tag: "youtube[12345]", error: nil)))
                }
                it("properly generates the correct views with only non-video strings") {
                    let output = self.richTextParser.getRichDataTypes(from: "Look at this!")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(equal(RichDataType.text(
                        richText: self.richTextParser.getRichTextWithErrors(from: "Look at this!").output,
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
                    let output = self.richTextParser.getRichTextWithErrors(from: MarkDownText.codeText).output
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

                    expect(deinitCalled).toEventually(beTrue(), timeout: .seconds(5))
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
        switch lhs {
        case .video(tag: let lhsTag, error: _):
            switch rhs {
            case .video(tag: let rhsTag, error: _):
                return lhsTag == rhsTag
            default:
                return false
            }
        case .text(richText: let lhsRichText, font: _, errors: _):
            switch rhs {
            case .text(richText: let rhsRichText, font: _, errors: _):
                return lhsRichText.string == rhsRichText.string
            default:
                return false
            }
        }
    }
}
