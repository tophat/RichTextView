//
//  UITextViewGeneratorSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class UITextViewGeneratorSpec: QuickSpec {
    override func spec() {
        describe("UITextViewGenerator") {
            context("Creation") {
                it("creates a label using an NSAttributedString") {
                    let attributedString = NSAttributedString(string: "some text")
                    let textView = UITextViewGenerator.getTextView(
                        from: attributedString,
                        font: UIFont.systemFont(ofSize: UIFont.systemFontSize),
                        textColor: .white,
                        isSelectable: true,
                        isEditable: false
                    )
                    expect(textView.attributedText?.string).to(equal("some text"))
                    expect(textView.accessibilityValue).to(equal("some text"))
                    expect(textView.isAccessibilityElement).to(beTrue())
                    expect(textView.textColor).to(equal(UIColor.white))
                    expect(textView.isSelectable).to(beTrue())
                    expect(textView.isEditable).to(beFalse())
                    expect(textView.isScrollEnabled).to(beFalse())
                    expect(textView.textContainerInset).to(equal(.zero))
                    if #available(iOS 10.0, *) {
                        expect(textView.adjustsFontForContentSizeCategory).to(beTrue())
                    }
                }
            }
        }
    }
}
