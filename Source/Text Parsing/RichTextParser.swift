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

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser(), font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) {
        self.latexParser = latexParser
        self.font = font
    }

    // MARK: - Utility Functions

    func getRichDataTypes(from input: String) -> [RichDataType] {
        var errors: [ParsingError]?
        return self.splitInputOnVideoPortions(input).compactMap { input -> RichDataType in
            if self.isStringAVideoTag(input) {
                return RichDataType.video(tag: input, error: nil)
            }
            let results = self.richTextToAttributedString(from: input)
            if errors == nil {
                errors = results.errors
            } else if let resultErrors = results.errors {
                errors?.append(contentsOf: resultErrors)
            }
            return RichDataType.text(richText: results.output, font: self.font, errors: errors)
        }
    }

    // MARK: - Helpers

    func richTextToAttributedString(from input: String) -> (output: NSAttributedString, errors: [ParsingError]?) {
        let components = self.seperateComponents(from: input)
        let results = self.generateAttributedStringArray(from: components)
        let attributedArray = results.output
        let mutableAttributedString = NSMutableAttributedString()
        for attributedString in attributedArray {
            mutableAttributedString.append(attributedString)
        }
        return (mutableAttributedString, results.errors)
    }

    func generateAttributedStringArray(from input: [String]) -> (output: [NSAttributedString], errors: [ParsingError]?) {
        var output = [NSAttributedString]()
        var errors: [ParsingError]?
        for element in input {
            if let attributedString = self.getAttributedText(from: element) {
                output.append(attributedString)
            } else {
                if var errors = errors {
                    errors.append(ParsingError.attributedTextGeneration(title: element))
                } else {
                    var tempErrors = [ParsingError]()
                    tempErrors.append(ParsingError.attributedTextGeneration(title: element))
                    errors = tempErrors
                }
            }
        }
        return (output, errors)
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
        return self.latexParser.extractLatex(from: input)
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
