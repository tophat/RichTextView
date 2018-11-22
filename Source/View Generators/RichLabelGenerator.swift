//
//  RichLabelGenerator.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

class RichLabelGenerator {

    // MARK: - Init

    private init() {}

    // MARK: - Utility Functions

    static func getLabel(from input: NSAttributedString, font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        let mutableInput = NSMutableAttributedString(attributedString: input)
        mutableInput.replaceFont(with: font)
        label.attributedText = mutableInput
        label.accessibilityValue = input.string
        label.isAccessibilityElement = true
        label.textColor = textColor
        label.numberOfLines = 0
        if #available(iOS 10.0, *) {
            label.adjustsFontForContentSizeCategory = true
        }
        return label
    }
}
