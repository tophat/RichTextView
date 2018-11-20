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
                    
                    expect(deinitCalled).toEventually(beTrue(), timeout: 5)
                }
            }
            context("Generate Array of Labels and Webviews") {
                it("properly generates the correct views with a mix of video and non-video strings") {
                    let output = richTextView.generateArrayOfLabelsAndWebviews(from: "Look at this video: youtube[12345]")
                    expect(output.count).to(equal(2))
                    expect(output[0]).to(beAKindOf(UILabel.self))
                    expect(output[1]).to(beAKindOf(WKWebView.self))
                }
                it("properly generates the correct views with only non-video strings") {
                    let output = richTextView.generateArrayOfLabelsAndWebviews(from: "Look at this!")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(beAKindOf(UILabel.self))
                }
                it("properly generates the correct views with only video strings") {
                    let output = richTextView.generateArrayOfLabelsAndWebviews(from: "youtube[12345]")
                    expect(output.count).to(equal(1))
                    expect(output[0]).to(beAKindOf(WKWebView.self))
                }

            }
        }
    }
}
