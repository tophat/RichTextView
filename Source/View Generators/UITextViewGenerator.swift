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

    static func getTextView(from input: NSAttributedString,
                            font: UIFont,
                            textColor: UIColor,
                            isSelectable: Bool,
                            isEditable: Bool,
                            textViewDelegate: RichTextViewDelegate?) -> UITextView {
        let textView = UITextView()
        let mutableInput = NSMutableAttributedString(attributedString: input)
        mutableInput.replaceFont(with: font)
        mutableInput.replaceColor(with: textColor)
        textView.attributedText = mutableInput
        textView.accessibilityValue = input.string
        textView.isAccessibilityElement = true
        textView.isSelectable = isSelectable
        textView.isEditable = isEditable
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        if #available(iOS 10.0, *) {
            textView.adjustsFontForContentSizeCategory = true
        }
        textView.delegate = textViewDelegate
        return textView
    }
}
