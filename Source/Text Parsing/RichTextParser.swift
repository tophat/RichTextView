//
//  RichTextParser.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Down

class RichTextParser {

    private enum ParserConstants {
        static let latexRegex = "\\[math\\](.*?)\\[\\/math\\]"
    }
    // MARK: - Dependencies

    let latexParser: LatexParserProtocol
    let font: UIFont
    let textColor: UIColor

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser(),
         font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
         textColor: UIColor = UIColor.black) {
        self.latexParser = latexParser
        self.font = font
        self.textColor = textColor
    }

    // MARK: - Utility Functions

    func getRichDataTypes(from input: String) -> [RichDataType] {
        return self.splitInputOnVideoPortions(input).compactMap { input -> RichDataType in
            if self.isStringAVideoTag(input) {
                return RichDataType.video(tag: input)
            }
            return RichDataType.text(richText: self.richTextToAttributedString(from: input), font: self.font)
        }
    }

    // MARK: - Helpers

    func richTextToAttributedString(from input: String) -> NSAttributedString {
        let components = self.seperateComponents(from: input)
        let attributedArray = self.generateAttributedStringArray(from: components)
        let mutableAttributedString = NSMutableAttributedString()
        for attributedString in attributedArray {
            mutableAttributedString.append(attributedString)
        }
        return mutableAttributedString
    }

    func generateAttributedStringArray(from input: [String]) -> [NSAttributedString] {
        var output = [NSAttributedString]()
        for element in input {
            if let attributedString = self.getAttributedText(from: element) {
                output.append(attributedString)
            } else {
                // TODO: #34 Add error handling
            }
        }
        return output
    }

    private func getAttributedText(from input: String) -> NSAttributedString? {
        if isTextLatex(input) {
            return self.extractLatex(from: input)
        }
        guard let attributedInput = try? Down(markdownString: self.stripCodeTagsIfNecessary(from: input)).toAttributedString() else {
            return nil
        }
        let mutableAttributedInput = NSMutableAttributedString(attributedString: attributedInput)
        mutableAttributedInput.replaceFont(with: self.font)
        return mutableAttributedInput
    }

    func seperateComponents(from input: String) -> [String] {
        let splitPositions = self.extractPositions(fromRanges: input.ranges(of: ParserConstants.latexRegex, options: .regularExpression))
        if splitPositions.count == 0 {
            return [input]
        }
        return input.split(
            atPositions: splitPositions
        )
    }

    func extractLatex(from input: String) -> NSAttributedString {
        return self.latexParser.extractLatex(from: input, textColor: self.textColor)
    }

    func isTextLatex(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.latexRegex, options: .regularExpression).count != 0
    }
    
    private func extractPositions(fromRanges ranges: [Range<String.Index>]) -> [String.Index] {
        return ranges.flatMap { range in
            return [range.lowerBound, range.upperBound]
        }.sorted()
    }

    private func splitInputOnVideoPortions(_ input: String) -> [String] {
        return input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
    }
    
    private func isStringAVideoTag(_ input: String) -> Bool {
        return input.range(of: RichTextViewConstants.videoTagRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    private func stripCodeTagsIfNecessary(from input: String) -> String {
        return input.replacingOccurrences(of: "[code]", with: "`").replacingOccurrences(of: "[/code]", with: "`")
    }
}
