//
//  StringExtensionSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class StringExtensionSpec: QuickSpec {
    override func spec() {
        describe("String Extension") {
            context("Get Substring In Between Tags") {
                it("gets string between two tags if it exists") {
                    let input = "[math]x^n[/math]"
                    let output = input.getSubstring(inBetween: "[math]", and: "[/math]")
                    expect(output).to(equal("x^n"))
                }
                it("returns nil if only the beginning tag exists") {
                    let input = "[math]x^n"
                    let output = input.getSubstring(inBetween: "[math]", and: "[/math]")
                    expect(output).to(beNil())
                }
                it("returns nil if only the end tag exists") {
                    let input = "x^n[/math]"
                    let output = input.getSubstring(inBetween: "[math]", and: "[/math]")
                    expect(output).to(beNil())
                }
                it("returns nil if one of the tags is an empty string") {
                    let input = "[math]x^n"
                    let output = input.getSubstring(inBetween: "[math]", and: "")
                    expect(output).to(beNil())
                }
            }
            context("Get Components Separated by Regex") {
                it("returns components correctly split if regex is in middle of string") {
                    let input = "Test youtube[123] wow"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["Test ", "youtube[123]", " wow"]))
                }
                it("returns components correctly split if regex is in beginning of string") {
                    let input = "youtube[123] wow"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["youtube[123]", " wow"]))
                }
                it("returns components correctly split if regex is in end of string") {
                    let input = "Test youtube[123]"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["Test ", "youtube[123]"]))
                }
                it("returns entire string in array if regex to split does not exist") {
                    let input = "Test wow"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["Test wow"]))
                }
            }
            context("Split") {
                it ("splits a string at the correct position") {
                    let initialString = "Text to be split"
                    let index = initialString.index(initialString.startIndex, offsetBy: 5)
                    let splitStrings = initialString.split(atPositions: [index])
                    expect(splitStrings.count).to(equal(2))
                    expect(splitStrings[0]).to(equal("Text "))
                    expect(splitStrings[1]).to(equal("to be split"))
                }
                it ("splits a string at the correct positions") {
                    let initialString = "Text to be split"
                    let indexes = [initialString.index(initialString.startIndex, offsetBy: 5),
                                   initialString.index(initialString.startIndex, offsetBy: 8),
                                   initialString.index(initialString.startIndex, offsetBy: 11)]
                    let splitStrings = initialString.split(atPositions: indexes)
                    expect(splitStrings.count).to(equal(4))
                    expect(splitStrings[0]).to(equal("Text "))
                    expect(splitStrings[1]).to(equal("to "))
                    expect(splitStrings[2]).to(equal("be "))
                    expect(splitStrings[3]).to(equal("split"))
                }
            }
            context("Ranges") {
                it("returns the ranges of given text") {
                    let initialString = "<p>Some text<p>"
                    let ranges = initialString.ranges(of: "<p>")
                    expect(ranges.count).to(equal(2))
                    expect(ranges[0].lowerBound.encodedOffset).to(equal(0))
                    expect(ranges[0].upperBound.encodedOffset).to(equal(3))
                    expect(ranges[1].lowerBound.encodedOffset).to(equal(12))
                    expect(ranges[1].upperBound.encodedOffset).to(equal(15))
                }
                it("returns the ranges of given text as a regular expression") {
                    let initialString = "[math]Some text[/math] different text [math]more text[/math]"
                    let ranges = initialString.ranges(of: "\\[math\\](.*?)\\[\\/math\\]", options: .regularExpression)
                    expect(ranges.count).to(equal(2))
                    expect(ranges[0].lowerBound.encodedOffset).to(equal(0))
                    expect(ranges[0].upperBound.encodedOffset).to(equal(22))
                    expect(ranges[1].lowerBound.encodedOffset).to(equal(38))
                    expect(ranges[1].upperBound.encodedOffset).to(equal(60))
                }
            }
        }
    }
}
