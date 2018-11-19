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
        }
    }
}
