//
//  RichLabelGeneratorSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class RichLabelGeneratorSpec: QuickSpec {
    override func spec() {
        describe("RichLabelGenerator") {
            context("Creation") {
                it("creates a label using an NSAttributedString") {
                    let attributedString = NSAttributedString(string: "some text")
                    let label = RichLabelGenerator.getLabel(from: attributedString, font: UIFont.systemFont(ofSize: UIFont.systemFontSize), textColor: .white)
                    expect(label.attributedText?.string).to(equal("some text"))
                    expect(label.accessibilityValue).to(equal("some text"))
                    expect(label.isAccessibilityElement).to(beTrue())
                    expect(label.textColor).to(equal(UIColor.white))
                    if #available(iOS 10.0, *) {
                        expect(label.adjustsFontForContentSizeCategory).to(beTrue())
                    }
                }
            }
        }
    }
}
