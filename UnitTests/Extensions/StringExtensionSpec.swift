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
        }
    }
}
