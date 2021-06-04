//
//  RichTextViewDelegate.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2019-03-15.
//  Copyright © 2019 Top Hat. All rights reserved.
//

@objc public protocol RichTextViewDelegate: UITextViewDelegate {
    @objc optional func canPerformRichTextViewAction(_ action: Selector, withSender sender: Any?) -> Bool
    @objc optional func copyMenuItemTapped()
    @objc optional func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}
