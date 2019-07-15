//
//  UIColorExtensionSpec.swift
//  RichTextView
//
//  Created by Simon Chau on 2019-07-04.
//  Copyright © 2019 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class UIColorExtensionSpec: QuickSpec {
    override func spec() {
        describe("UIColor Extension") {
            context("replace color") {
                it("Properly replaces font color") {
                    let firstColor = UIColor.black
                    let secondColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    let thirdColor = UIColor.red
                    let isFirstColorEqualToSecondColor = firstColor == secondColor
                    let isFirstColorEqualToThirdColor = firstColor == thirdColor
                    expect(isFirstColorEqualToSecondColor).to(beTrue())
                    expect(isFirstColorEqualToThirdColor).to(beFalse())
                }
            }
        }
    }
}
