//
//  UITextViewGenerator.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

extension UITextView {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let richTextViewDelegate = self.delegate as? RichTextViewDelegate,
            let canPerformAction = richTextViewDelegate.canPerformRichTextViewAction?(action, withSender: sender) {
            return canPerformAction
        }
        return super.canPerformAction(action, withSender: sender)
    }

    override open func copy(_ sender: Any?) {
        guard let selectedRange = self.selectedTextRange else {
            return
        }
        UIPasteboard.general.string = self.text(in: selectedRange)
        if let richTextViewDelegate = self.delegate as? RichTextViewDelegate, let copyMenuItemtappedMethod = richTextViewDelegate.copyMenuItemTapped {
            copyMenuItemtappedMethod()
        }
    }
}

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
        //disable accesibility if input is emtry string
        textView.isAccessibilityElement = !input.string.isEmpty
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
        if let linkID = textView.attributedText?.attribute(.customLink, at: tappedCharacterIndex, effectiveRange: nil) as? String,
            let richTextViewDelegate = textView.delegate as? RichTextViewDelegate {
            richTextViewDelegate.didTapCustomLink(withID: linkID)
        }
    }
}
