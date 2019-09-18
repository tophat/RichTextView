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
            context("Replace Font Color") {
                it("successfully replaces the font color") {
                    let attributedText = NSMutableAttributedString(string: "Hello, world", attributes: [
                        .foregroundColor: UIColor.black
                    ])
                    var attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.foregroundColor] as? UIColor).to(equal(UIColor.black))
                    attributedText.replaceColor(with: UIColor.red)
                    attributes = attributedText.attributes(at: 0, effectiveRange: nil)
                    expect(attributes[.foregroundColor] as? UIColor).to(equal(UIColor.red))
                }
            }
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
            context("Trim trailing newlines and whitespaces") {
                it("Trims trailing spaces") {
                    var attributedString = NSMutableAttributedString(string: "Test     ")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("Test"))
                }
                it("Trims trailing newlines") {
                    var attributedString = NSMutableAttributedString(string: "Test\n\n\n\n\n")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("Test"))
                }
                it("Trims input only has newlines") {
                    var attributedString = NSMutableAttributedString(string: "\n\n\n\n\n")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal(""))
                }
                it("Does not trim leading spaces") {
                    var attributedString = NSMutableAttributedString(string: "     Test")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("     Test"))
                }
                it("Does not trim leading newlines") {
                    var attributedString = NSMutableAttributedString(string: "\n\n\n\n\nTest")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("\n\n\n\n\nTest"))
                }
            }
            context("Trim trailing newlines") {
                it("Does not trim trailing spaces") {
                    var attributedString = NSMutableAttributedString(string: "Test     ")
                    attributedString = attributedString.trimmingTrailingNewlines()
                    expect(attributedString.string).to(equal("Test     "))
                }
                it("Trims trailing newlines") {
                    var attributedString = NSMutableAttributedString(string: "Test\n\n\n\n\n")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("Test"))
                }
                it("Trims input only has newlines") {
                    var attributedString = NSMutableAttributedString(string: "\n\n\n\n\n")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal(""))
                }
                it("Does not trim leading spaces") {
                    var attributedString = NSMutableAttributedString(string: "     Test")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("     Test"))
                }
                it("Does not trim leading newlines") {
                    var attributedString = NSMutableAttributedString(string: "\n\n\n\n\nTest")
                    attributedString = attributedString.trimmingTrailingNewlinesAndWhitespaces()
                    expect(attributedString.string).to(equal("\n\n\n\n\nTest"))
                }
            }
            context("Custom Link Attribute") {
                it("property adds custom link attribute") {
                    let attributedString = NSAttributedString(string: "Test", attributes: [.customLink: "Test"])
                    expect(attributedString.attribute(.customLink, at: 0, effectiveRange: nil) as? String).to(equal("Test"))
                    expect(attributedString.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor).to(beNil())
                }
            }
        }
    }
}
