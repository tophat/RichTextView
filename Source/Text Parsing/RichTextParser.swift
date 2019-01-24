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
    let latexTextBaselineOffset: CGFloat

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser(),
         font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
         textColor: UIColor = UIColor.black,
         latexTextBaselineOffset: CGFloat = 0) {
        self.latexParser = latexParser
        self.font = font
        self.textColor = textColor
        self.latexTextBaselineOffset = latexTextBaselineOffset
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
            let result = self.getAttributedText(from: element)
            output.append(result.output)
            guard let error = result.error else {
                continue
            }
            if errors == nil {
                errors = [ParsingError]()
            }
            errors?.append(error)
        }
        return (output, errors)
    }

    private func getAttributedText(from input: String) -> (output: NSAttributedString, error: ParsingError?) {
        if self.isTextLatex(input) {
            guard let latex = self.extractLatex(from: input) else {
                return (NSAttributedString(string: input), ParsingError.latexGeneration(text: input))
            }
            return (latex, nil)
        }
        if Thread.isMainThread {
            return self.getAttributedTextFromDown(with: input)
        }

        var output = NSAttributedString(string: "")
        var parsingError: ParsingError?

        DispatchQueue.main.sync {
            (output, parsingError) = self.getAttributedTextFromDown(with: input)
        }

        return (output, parsingError)
    }

    private func getAttributedTextFromDown(with input: String) -> (output: NSAttributedString, error: ParsingError?) {
        guard let attributedInput = try? Down(markdownString: self.stripCodeTagsIfNecessary(from: input)).toAttributedString() else {
            return (NSAttributedString(string: input), ParsingError.attributedTextGeneration(text: input))
        }

        let mutableAttributedInput = NSMutableAttributedString(attributedString: attributedInput)
        mutableAttributedInput.replaceFont(with: self.font)
        return (mutableAttributedInput.trimmingTrailingNewlinesAndWhitespaces(), nil)
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

    func extractLatex(from input: String) -> NSAttributedString? {
        return self.latexParser.extractLatex(from: input, textColor: self.textColor, baselineOffset: self.latexTextBaselineOffset)
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
