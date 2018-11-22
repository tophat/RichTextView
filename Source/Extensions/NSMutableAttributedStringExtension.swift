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
        let defaultFontSize = UIFont.smallSystemFontSize
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, _) in
            guard let oldFont = value as? UIFont,
                let newFontDescriptor = newFont.fontDescriptor.withSymbolicTraits(oldFont.fontDescriptor.symbolicTraits) else {
                return
            }
            let mergedSize = oldFont.pointSize == defaultFontSize ? newFont.pointSize : oldFont.pointSize
            let mergedFont = UIFont(descriptor: newFontDescriptor, size: mergedSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: mergedFont, range: range)
        }
        self.endEditing()
    }

    func trimmingTrailingNewlinesAndWhitespaces() -> NSMutableAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted

        let range = (self.string as NSString).rangeOfCharacter(from: invertedSet, options: .backwards)
        let length = (range.length > 0 ? NSMaxRange(range) : self.string.count)

        return NSMutableAttributedString(attributedString: self.attributedSubstring(from: NSRange(location: 0, length: length)))
    }
}
