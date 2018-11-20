//
//  RichViewGenerator.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-20.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble
import WebKit

@testable import RichTextView

class RichViewGeneratorSpec: QuickSpec {
    override func spec() {
        describe("RichViewGenerator") {
            it("properly generates the correct views with a mix of video and non-video strings") {
                let output = RichViewGenerator.generateArrayOfLabelsAndWebviews(from: "Look at this video: youtube[12345]")
                expect(output.count).to(equal(2))
                expect(output[0]).to(beAKindOf(UILabel.self))
                expect(output[1]).to(beAKindOf(WKWebView.self))
            }
            it("properly generates the correct views with only non-video strings") {
                let output = RichViewGenerator.generateArrayOfLabelsAndWebviews(from: "Look at this!")
                expect(output.count).to(equal(1))
                expect(output[0]).to(beAKindOf(UILabel.self))
            }
            it("properly generates the correct views with only video strings") {
                let output = RichViewGenerator.generateArrayOfLabelsAndWebviews(from: "youtube[12345]")
                expect(output.count).to(equal(1))
                expect(output[0]).to(beAKindOf(WKWebView.self))
            }
        }
    }
}
