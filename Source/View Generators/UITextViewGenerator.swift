//
//  UITextViewGenerator.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

class UITextViewGenerator {

    // MARK: - Init

    private init() {}

    // MARK: - Utility Functions

    static func getTextView(from input: NSAttributedString, font: UIFont, textColor: UIColor, isSelectable: Bool, isEditable: Bool) -> UITextView {
        let textView = UITextView()
        let mutableInput = NSMutableAttributedString(attributedString: input)
        mutableInput.replaceFont(with: font)
        textView.attributedText = mutableInput
        textView.accessibilityValue = input.string
        textView.isAccessibilityElement = true
        textView.textColor = textColor
        textView.isSelectable = isSelectable
        textView.isEditable = isEditable
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        if #available(iOS 10.0, *) {
            textView.adjustsFontForContentSizeCategory = true
        }
        return textView
    }
}
