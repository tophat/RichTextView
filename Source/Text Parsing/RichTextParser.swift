//
//  RichTextParser.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Down

class RichTextParser {

    enum ParserConstants {
        static let mathTagName = "math"
        static let interactiveElementTagName = "interactive-element"
        static let latexRegex = "\\[\(ParserConstants.mathTagName)\\](.*?)\\[\\/\(ParserConstants.mathTagName)\\]"
        static let interactiveElementRegex = """
        \\[\(ParserConstants.interactiveElementTagName)\\sid=.+?\\].*?\\[\\/\(ParserConstants.interactiveElementTagName)\\]
        """
        typealias RichTextWithErrors = (output: NSAttributedString, errors: [ParsingError]?)
    }

    // MARK: - Dependencies

    let latexParser: LatexParserProtocol
    let font: UIFont
    let textColor: UIColor
    let latexTextBaselineOffset: CGFloat
    let interactiveTextColor: UIColor

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser(),
         font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
         textColor: UIColor = UIColor.black,
         latexTextBaselineOffset: CGFloat = 0,
         interactiveTextColor: UIColor = UIColor.blue) {
        self.latexParser = latexParser
        self.font = font
        self.textColor = textColor
        self.latexTextBaselineOffset = latexTextBaselineOffset
        self.interactiveTextColor = interactiveTextColor
    }

    // MARK: - Utility Functions

    func getRichDataTypes(from input: String) -> [RichDataType] {
        var errors: [ParsingError]?
        return self.splitInputOnVideoPortions(input).compactMap { input -> RichDataType in
            if self.isStringAVideoTag(input) {
                return RichDataType.video(tag: input, error: nil)
            }
            let results = self.getAttributedText(from: input)
            if errors == nil {
                errors = results.errors
            } else if let resultErrors = results.errors {
                errors?.append(contentsOf: resultErrors)
            }
            return RichDataType.text(richText: results.output, font: self.font, errors: errors)
        }
    }

    // MARK: - Helpers

    func getAttributedText(from input: String) -> ParserConstants.RichTextWithErrors {
        if Thread.isMainThread {
            return self.getAttributedTextFromDown(with: input)
        }

        var output = NSAttributedString(string: "")
        var parsingErrors: [ParsingError]?

        DispatchQueue.main.sync {
            (output, parsingErrors) = self.getAttributedTextFromDown(with: input)
        }

        return (output, parsingErrors)
    }

    private func getAttributedTextFromDown(with input: String) -> ParserConstants.RichTextWithErrors {
        let strippedInput = self.stripCodeTagsIfNecessary(from: input)
        let strippedInputAsMutableAttributedString = NSMutableAttributedString(string: strippedInput)
        let strippedInputWithSpecialDataTypesHandled = self.getAttributedStringWithSpecialDataTypesHandled(
            from: strippedInputAsMutableAttributedString
        )
        let strippedInputAsAttributedString = strippedInputWithSpecialDataTypesHandled.output
        var allParsingErrors = strippedInputWithSpecialDataTypesHandled.errors
        let rangeOfStrippedInputAttributedString = NSRange(location: 0, length: strippedInputAsAttributedString.length)
        let outputAttributedStringToReturn = NSMutableAttributedString(attributedString: strippedInputWithSpecialDataTypesHandled.output)

        strippedInputAsAttributedString.enumerateAttributes(in: rangeOfStrippedInputAttributedString) { (attributes, range, _) in
            let parsedOutputWithErrors = self.parseHTMLAndMarkdown(
                inAttributes: attributes,
                range: range,
                entireAttributedString: strippedInputAsAttributedString
            )
            if let attributedString = parsedOutputWithErrors.0 {
                let substring = strippedInputAsAttributedString.string[range.lowerBound..<range.upperBound]
                let outputAttributedStringRange = (outputAttributedStringToReturn.string as NSString).range(of: substring)
                outputAttributedStringToReturn.replaceCharacters(in: outputAttributedStringRange, with: attributedString)
            }
            if let error = parsedOutputWithErrors.1 {
                if allParsingErrors == nil {
                    allParsingErrors = [ParsingError]()
                }
                allParsingErrors?.append(error)
            }
        }
        return (outputAttributedStringToReturn.trimmingTrailingNewlinesAndWhitespaces(), allParsingErrors)
    }

    private func parseHTMLAndMarkdown(inAttributes attributes: [NSAttributedString.Key: Any],
                                      range: NSRange,
                                      entireAttributedString: NSAttributedString) -> (NSMutableAttributedString?, ParsingError?) {
        guard attributes[.attachment] == nil else {
            return (nil, nil)
        }
        let relevantString = entireAttributedString.string[range.lowerBound..<range.upperBound]
        guard let attributedInput = try? Down(markdownString: relevantString).toAttributedString(.unsafe, stylesheet: nil) else {
            return (nil, ParsingError.attributedTextGeneration(text: relevantString))
        }
        let mutableAttributedInput = NSMutableAttributedString(attributedString: attributedInput)
        if !attributes.isEmpty {
            mutableAttributedInput.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedInput.length))
        }
        mutableAttributedInput.replaceFont(with: self.font)
        mutableAttributedInput.replaceColor(with: self.textColor)
        return (mutableAttributedInput.trimmingTrailingNewlines(), nil)
    }

    private func getAttributedStringWithSpecialDataTypesHandled(from mutableAttributedString: NSMutableAttributedString) -> ParserConstants.RichTextWithErrors {
        let interactiveElementPositions = self.extractPositions(
            fromRanges: mutableAttributedString.string.ranges(of: ParserConstants.interactiveElementRegex, options: .regularExpression)
        )
        let latexPositions = self.extractPositions(
            fromRanges: mutableAttributedString.string.ranges(of: ParserConstants.latexRegex, options: .regularExpression)
        )
        let splitPositions = interactiveElementPositions + latexPositions
        if splitPositions.isEmpty {
            return (mutableAttributedString.trimmingTrailingNewlinesAndWhitespaces(), nil)
        }
        return self.getRichTextWithErrors(fromComponents: self.split(mutableAttributedString: mutableAttributedString, onPositions: splitPositions))
    }

    private func split(mutableAttributedString: NSMutableAttributedString, onPositions positions: [String.Index]) -> [NSAttributedString] {
        let splitStrings = mutableAttributedString.string.split(atPositions: positions)
        var output = [NSAttributedString]()
        for string in splitStrings {
            let range = (mutableAttributedString.string as NSString).range(of: string)
            let attributedString = mutableAttributedString.attributedSubstring(from: range)
            output.append(attributedString)
        }
        return output
    }

    private func getRichTextWithErrors(fromComponents attributedStringComponents: [NSAttributedString]) -> ParserConstants.RichTextWithErrors {
        let output = NSMutableAttributedString()
        var parsingErrors: [ParsingError]?
        for attributedString in attributedStringComponents {
            if self.isTextInteractiveElement(attributedString.string) {
                output.append(self.extractInteractiveElement(from: attributedString))
            } else if self.isTextLatex(attributedString.string) {
                if let attributedLatexString = self.extractLatex(from: attributedString.string) {
                    output.append(attributedLatexString)
                } else {
                    if parsingErrors == nil {
                        parsingErrors = [ParsingError]()
                    }
                    output.append(attributedString)
                    parsingErrors?.append(ParsingError.latexGeneration(text: attributedString.string))
                }
            } else {
                output.append(attributedString)
            }
        }
        return (output.trimmingTrailingNewlinesAndWhitespaces(), parsingErrors)
    }

    func extractLatex(from input: String) -> NSAttributedString? {
        return self.latexParser.extractLatex(
            from: input,
            textColor: self.textColor,
            baselineOffset: self.latexTextBaselineOffset,
            fontSize: self.font.pointSize
        )
    }

    func extractInteractiveElement(from input: NSAttributedString) -> NSMutableAttributedString {
        let interactiveElementTagName = ParserConstants.interactiveElementTagName
        let interactiveElementID = input.string.getSubstring(inBetween: "[\(interactiveElementTagName) id=", and: "]") ?? input.string
        let interactiveElementText = input.string.getSubstring(inBetween: "]", and: "[/\(interactiveElementTagName)]") ?? input.string
        let attributes: [NSAttributedString.Key: Any] = [
            .customLink: interactiveElementID,
            .foregroundColor: self.interactiveTextColor,
            .font: self.font
        ].merging(input.attributes(at: 0, effectiveRange: nil)) { (current, _) in current }
        let mutableAttributedInput = NSMutableAttributedString(string: " " + interactiveElementText + " ", attributes: attributes)
        return mutableAttributedInput
    }

    func isTextLatex(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.latexRegex, options: .regularExpression).count != 0
    }

    func isTextInteractiveElement(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.interactiveElementRegex, options: .regularExpression).count != 0
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
