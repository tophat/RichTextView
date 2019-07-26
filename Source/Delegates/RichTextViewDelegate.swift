//
//  RichTextViewDelegate.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2019-03-15.
//  Copyright © 2019 Top Hat. All rights reserved.
//

public protocol RichTextViewDelegate: UITextViewDelegate {
    func didTapCustomLink(withID linkID: String)
}
