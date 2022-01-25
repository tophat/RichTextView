//
//  RichTextViewSpec.swift
//  RichTextViewUnitTests
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble
import WebKit

@testable import RichTextView

class RichTextViewSpec: QuickSpec {

    override func spec() {
        var richTextView: RichTextView!

        describe("RichTextViewSpec") {
            beforeEach {
                richTextView = RichTextView(frame: CGRect.zero)
            }
            context("Memory leaks") {
                it("successfully deallocates without any retain cycles") {
                    class RichTextViewWithMemoryLeakChecking: RichTextView {
                        var deinitCalled: (() -> Void)?
                        deinit {
                            deinitCalled?()
                        }
                    }
                    var deinitCalled = false

                    var instance: RichTextViewWithMemoryLeakChecking? = RichTextViewWithMemoryLeakChecking(frame: .zero)
                    instance?.deinitCalled = {
                        deinitCalled = true
                    }
                    DispatchQueue.global(qos: .background).async {
                        instance = nil
                    }
                    expect(deinitCalled).toEventually(beTrue(), timeout: .seconds(5))
                }
            }
            context("Generate Array of Labels and Webviews") {
                it("properly generates the correct views with a mix of video and non-video strings") {
                    richTextView.update(input: "Look at this video: youtube[12345]")
                    let output = richTextView.generateViews()
                    expect(output.count).to(equal(2))
                    expect(output[0]).to(beAKindOf(UITextView.self))
                    expect(output[1]).to(beAKindOf(WKWebView.self))
                }
                it("properly generates the correct views with only non-video strings") {
                    richTextView.update(input: "Look at this!")
                    let output = richTextView.generateViews()
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(beAKindOf(UITextView.self))
                }
                it("properly generates the correct views with only video strings") {
                    richTextView.update(input: "youtube[12345]")
                    let output = richTextView.generateViews()
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(beAKindOf(WKWebView.self))
                }
            }
            // Empty Commit(To test permissions)
            context("Update") {
                it("properly updates the input") {
                    richTextView?.update(input: "Test")
                    expect(richTextView?.input).to(equal("Test"))
                }
                it("properly updates the font") {
                    richTextView?.update(font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize))
                    expect(richTextView?.richTextParser.font).to(equal(UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)))
                }
                it("properly updates the text color") {
                    richTextView?.update(textColor: UIColor.red)
                    expect(richTextView?.textColor).to(equal(UIColor.red))
                    expect(richTextView?.richTextParser.textColor).to(equal(UIColor.red))
                }
                it("properly updates the accessibility value") {
                    richTextView?.update(input: "Testing accessibility value")
                    expect(richTextView?.accessibilityValue).to(equal("Testing accessibility value"))
                }
                it("properly updates the accessibility value when input text change") {
                    richTextView?.update(input: "Testing accessibility value")
                    expect(richTextView?.accessibilityValue).to(equal("Testing accessibility value"))
                    richTextView?.update(input: "New input")
                    expect(richTextView?.accessibilityValue).to(equal("New input"))
                }
            }
        }
    }
}
