//
//  RichViewGenerator.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-20.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Foundation

class RichViewGenerator {

    // MARK: - Init

    private init() {}

    // MARK: - Helper Functions

    static func generateArrayOfLabelsAndWebviews(from input: String) -> [UIView] {
        return self.splitInputOnVideoPortions(input).compactMap { input -> UIView? in
            return self.isStringAVideoTag(input) ? RichWebViewGenerator.getWebView(from: input) : RichLabelGenerator.getLabel(from: input)
        }
    }

    private static func splitInputOnVideoPortions(_ input: String) -> [String] {
        return input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
    }

    private static func isStringAVideoTag(_ input: String) -> Bool {
        return input.range(of: RichTextViewConstants.videoTagRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
