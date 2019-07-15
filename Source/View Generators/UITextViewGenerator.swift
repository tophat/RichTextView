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
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UITextViewGenerator.handleCustomLinkTapOnTextViewIfNecessary(_:))))
        if #available(iOS 10.0, *) {
            textView.adjustsFontForContentSizeCategory = true
        }
        textView.delegate = textViewDelegate
        return textView
    }

    @objc static func handleCustomLinkTapOnTextViewIfNecessary(_ recognizer: UITapGestureRecognizer) {
        guard let textView = recognizer.view as? UITextView else {
            return
        }

        var location = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        let tappedCharacterIndex = textView.layoutManager.characterIndex(
            for: location,
            in: textView.textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        guard tappedCharacterIndex < textView.textStorage.length else {
            return
        }
        if let linkText = textView.attributedText?.attribute(.customLink, at: tappedCharacterIndex, effectiveRange: nil) as? String,
            let richTextViewDelegate = textView.delegate as? RichTextViewDelegate {
            richTextViewDelegate.didTapCustomLink(withText: linkText)
        }
    }
}
