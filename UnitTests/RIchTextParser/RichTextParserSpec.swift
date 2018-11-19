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
        static let basicMarkdown = "**More Text**"
    }

    var richTextParser: RichTextParser!

    override func spec() {
        describe("RichTextParser") {
            context("HTML parsing") {
                beforeEach {
                    self.richTextParser = RichTextParser()
                }
                it("successfully identifies various HTML text") {
                    expect(self.richTextParser.isTextHTML(MarkDownText.regularText)).to(beFalse())
                }
                it("succssfully rejects non-HTML text") {

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
