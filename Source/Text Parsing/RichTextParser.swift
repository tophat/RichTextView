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
        static let highlightedElementTagName = "highlighted-element"
        static let latexRegex = "\\[\(ParserConstants.mathTagName)\\](.*?)\\[\\/\(ParserConstants.mathTagName)\\]"
        static let latexRegexCaptureGroupIndex = 0
        static let interactiveElementRegex = """
        \\[\(ParserConstants.interactiveElementTagName)\\sid=.+?\\].*?\\[\\/\(ParserConstants.interactiveElementTagName)\\]
        """
        static let highlightedElementRegex = """
        \\[\(ParserConstants.highlightedElementTagName)\\sid=.+?\\].*?\\[\\/\(ParserConstants.highlightedElementTagName)\\]
        """
        typealias RichTextWithErrors = (output: NSAttributedString, errors: [ParsingError]?)
    }

    // MARK: - Dependencies

    let latexParser: LatexParserProtocol
    let font: UIFont
    let textColor: UIColor
    let latexTextBaselineOffset: CGFloat
    let interactiveTextColor: UIColor
    let attributes: [String: [NSAttributedString.Key: Any]]?

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser(),
         font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
         textColor: UIColor = UIColor.black,
         latexTextBaselineOffset: CGFloat = 0,
         interactiveTextColor: UIColor = UIColor.blue,
         attributes: [String: [NSAttributedString.Key: Any]]? = nil) {
        self.latexParser = latexParser
        self.font = font
        self.textColor = textColor
        self.latexTextBaselineOffset = latexTextBaselineOffset
        self.interactiveTextColor = interactiveTextColor
        self.attributes = attributes
    }

    // MARK: - Utility Functions

    func getRichDataTypes(from input: String) -> [RichDataType] {
        var errors: [ParsingError]?
        if input == "" {
            return [RichDataType.text(richText: NSAttributedString(string: ""), font: self.font, errors: nil)]
        }
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

    func getAttributedText(from input: String) -> ParserConstants.RichTextWithErrors {
        let strippedInput = self.stripCodeTagsIfNecessary(from: input)
        let strippedInputAsMutableAttributedString = NSMutableAttributedString(string: strippedInput)
        let strippedInputWithSpecialDataTypesHandled = self.getAttributedStringWithSpecialDataTypesHandled(
            from: strippedInputAsMutableAttributedString
        )
        let parsingErrors = strippedInputWithSpecialDataTypesHandled.errors
        let outputAttributedStringToReturn = NSMutableAttributedString(attributedString: strippedInputWithSpecialDataTypesHandled.output)
        let HTMLAndMarkdownParsedString = self.parseHTMLAndMarkdown(withAttributedString: outputAttributedStringToReturn, parsingErrors: parsingErrors)
        let mutableAttributedInput = HTMLAndMarkdownParsedString.0
        let allParsingErrors = HTMLAndMarkdownParsedString.1
        let parsedStringWithAttributes = self.getAttributesIfNecessary(
            fromAttributedString: strippedInputWithSpecialDataTypesHandled.output,
            parsedString: mutableAttributedInput
        )
        parsedStringWithAttributes.replaceFont(with: self.font)
        parsedStringWithAttributes.replaceColor(with: self.textColor)
        return (parsedStringWithAttributes.trimmingTrailingNewlinesAndWhitespaces(), allParsingErrors)
    }

    // MARK: - Helpers

    private func getAttributesIfNecessary(fromAttributedString attributedString: NSAttributedString,
                                          parsedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let rangeOfAttributedString = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttributes(in: rangeOfAttributedString) { (attributes, range, _) in
            if attributes.isEmpty {
                return
            }
            let substring = attributedString.string[
                max(range.lowerBound, 0)..<min(range.upperBound, attributedString.string.count)
            ]
            let rangeInOutput = (parsedString.string as NSString).range(of: substring)
            if range.location == NSNotFound || range.location < 0 || rangeInOutput.location + rangeInOutput.length > parsedString.length {
                return
            }
            let attributedSubstring = NSAttributedString(string: substring, attributes: attributes)
            parsedString.replaceCharacters(in: rangeInOutput, with: attributedSubstring)
        }
        return parsedString
    }

    private func parseHTMLAndMarkdown(withAttributedString mutableAttributedString: NSMutableAttributedString,
                                      parsingErrors: [ParsingError]?) -> (NSMutableAttributedString, [ParsingError]?) {
        var allParsingErrors: [ParsingError]? = parsingErrors
        let relevantString = mutableAttributedString.string
        let cleanRelevantString = relevantString.replaceTrailingWhiteSpaceWithNonBreakingSpace().replaceLeadingWhiteSpaceWithNonBreakingSpace()
        guard let inputAsHTMLString = try? Down(markdownString: cleanRelevantString).toHTML([.unsafe, .hardBreaks]),
            let inputAsHTMLWithZeroWidthSpaceRemoved = inputAsHTMLString.replaceAppropiateZeroWidthSpaces(),
            let htmlData = inputAsHTMLWithZeroWidthSpaceRemoved.data(using: .utf8) else {
                if allParsingErrors == nil {
                    allParsingErrors = [ParsingError]()
                }
                allParsingErrors?.append(ParsingError.attributedTextGeneration(text: relevantString))
                return (mutableAttributedString.trimmingTrailingNewlinesAndWhitespaces(), allParsingErrors)
        }
        var attributedString: NSAttributedString?
        if Thread.isMainThread {
            attributedString = try? NSAttributedString(data: htmlData, options:
                [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } else {
            DispatchQueue.main.sync {
                attributedString = try? NSAttributedString(data: htmlData, options:
                    [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            }
        }
        guard let attributedStringNonOptional = attributedString else {
            if allParsingErrors == nil {
                allParsingErrors = [ParsingError]()
            }
            allParsingErrors?.append(ParsingError.attributedTextGeneration(text: relevantString))
            return (mutableAttributedString.trimmingTrailingNewlinesAndWhitespaces(), allParsingErrors)
        }
        let mutableAttributedInput = NSMutableAttributedString(attributedString: attributedStringNonOptional)
        return (mutableAttributedInput, allParsingErrors)
    }

    private func getAttributedStringWithSpecialDataTypesHandled(from mutableAttributedString: NSMutableAttributedString) -> ParserConstants.RichTextWithErrors {
        let interactiveElementPositions = self.extractPositions(
            fromRanges: mutableAttributedString.string.ranges(of: ParserConstants.interactiveElementRegex, options: .regularExpression)
        )
        let highlightedElementPositions = self.extractPositions(
            fromRanges: mutableAttributedString.string.ranges(of: ParserConstants.highlightedElementRegex, options: .regularExpression)
        )
        let latexPositions = self.extractPositions(fromRanges: self.getLatexRanges(inText: mutableAttributedString.string))
        let splitPositions = interactiveElementPositions + latexPositions + highlightedElementPositions
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
            } else if self.isTextHighlightedElement(attributedString.string) {
                output.append(self.extractHighlightedElement(from: attributedString))
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
            fontSize: self.font.pointSize,
            height: calculateContentHeight()
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
        let mutableAttributedInput = NSMutableAttributedString(string: interactiveElementText, attributes: attributes)
        return mutableAttributedInput
    }

    func extractHighlightedElement(from input: NSAttributedString) -> NSMutableAttributedString {
        let highlightedElementTagName = ParserConstants.highlightedElementTagName
        let highlightedElementID = input.string.getSubstring(inBetween: "[\(highlightedElementTagName) id=", and: "]") ?? input.string
        let highlightedElementText = input.string.getSubstring(inBetween: "]", and: "[/\(highlightedElementTagName)]") ?? input.string
        guard let richTextAttributes = self.attributes?[highlightedElementID] else {
            return NSMutableAttributedString(string: highlightedElementText)
        }
        let attributes: [NSAttributedString.Key: Any] = [.highlight: highlightedElementID]
        .merging(input.attributes(at: 0, effectiveRange: nil)) { (current, _) in current }
        .merging(richTextAttributes) { (current, _) in current }
        let mutableAttributedInput = NSMutableAttributedString(string: highlightedElementText, attributes: attributes)
        return mutableAttributedInput
    }

    func isTextLatex(_ text: String) -> Bool {
        return !self.getLatexRanges(inText: text).isEmpty
    }

    func isTextInteractiveElement(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.interactiveElementRegex, options: .regularExpression).count != 0
    }

    func isTextHighlightedElement(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.highlightedElementRegex, options: .regularExpression).count != 0
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

    private func getLatexRanges(inText text: String) -> [Range<String.Index>] {
        guard let regex = try? NSRegularExpression(pattern: ParserConstants.latexRegex, options: [.caseInsensitive, .dotMatchesLineSeparators]) else {
            return []
        }
        let range = NSRange(location: 0, length: text.count)
        let matches = regex.matches(in: text, range: range)
        return matches.compactMap { match in
            return Range<String.Index>(match.range(at: ParserConstants.latexRegexCaptureGroupIndex), in: text)
        }
    }

    private func calculateContentHeight() -> CGFloat {
        let frame = NSString(string: "").boundingRect(
            with: CGSize(width: 0, height: .max),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font: self.font],
            context: nil)

        return frame.size.height
    }
}
