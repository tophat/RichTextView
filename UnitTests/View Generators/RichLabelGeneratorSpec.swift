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
                    let label = RichLabelGenerator.getLabel(from: attributedString)
                    expect(label.attributedText?.string).to(equal("some text"))
                }
            }
        }
    }
}
