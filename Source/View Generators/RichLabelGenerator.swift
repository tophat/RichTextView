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
        label.attributedText = input
        label.accessibilityValue = input.string
        label.isAccessibilityElement = true
        label.adjustsFontForContentSizeCategory = true
        label.font = font
        label.textColor = textColor
        return label
    }
}
