//
//  NSMutableAttributedStringExtension.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-20.
//  Copyright © 2018 Top Hat. All rights reserved.
//

extension NSMutableAttributedString {
    func replaceFont(with newFont: UIFont) {
        self.beginEditing()
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            guard let oldFont = value as? UIFont,
                let newFontDescriptor = newFont.fontDescriptor.withSymbolicTraits(oldFont.fontDescriptor.symbolicTraits) else {
                return
            }
            let mergedFont = UIFont(descriptor: newFontDescriptor, size: oldFont.pointSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: mergedFont, range: range)
        }
        self.endEditing()
    }
}
