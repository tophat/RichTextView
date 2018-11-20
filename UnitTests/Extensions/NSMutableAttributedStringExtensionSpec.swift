//
//  NSMutableAttributedStringExtensionSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-20.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class NSMutableAttributedStringExtensionSpec: QuickSpec {
    override func spec() {
        describe("NSMutableAttributedString Extension") {
            context("Replace Font Family") {
                it("successfully replaces the font family while retaining size") {
                    let attributedText = NSMutableAttributedString(string: "Hello, world", attributes: [
                        .font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    ])

                    var attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.font] as? UIFont).to(equal(UIFont.systemFont(ofSize: UIFont.systemFontSize)))

                    attributedText.replaceFont(with: UIFont(name: "Copperplate", size: UIFont.smallSystemFontSize)!)
                    attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.font] as? UIFont).to(equal(UIFont(name: "Copperplate", size: UIFont.systemFontSize)))
                }
                it("successfully replaces the font family while retaining weight") {
                    let attributedText = NSMutableAttributedString(string: "Hello, world", attributes: [
                        .font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    ])
                    
                    var attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.font] as? UIFont).to(equal(UIFont.systemFont(ofSize: UIFont.systemFontSize)))

                    attributedText.replaceFont(with: UIFont(name: "Copperplate-Light", size: UIFont.systemFontSize)!)
                    attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.font] as? UIFont).to(equal(UIFont(name: "Copperplate", size: UIFont.systemFontSize)))
                }
                it("successfully replaces the font family while retaining style") {
                    let attributedText = NSMutableAttributedString(string: "Hello, world", attributes: [
                        .font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
                        ])
                    
                    var attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.font] as? UIFont).to(equal(UIFont.systemFont(ofSize: UIFont.systemFontSize)))
                    
                    attributedText.replaceFont(with: UIFont(name: "CourierNewPS-BoldItalicMT", size: UIFont.systemFontSize)!)
                    attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.font] as? UIFont).to(equal(UIFont(name: "CourierNewPSMT", size: UIFont.systemFontSize)))
                }
            }
        }
    }
}

