//
//  RichTextParser.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Down

class RichTextParser {

    // MARK: - Constants

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
        private static let tAPlaceholderPrefix = "{RichTextView-TextAttachmentPosition"
        private static let tAPlaceholderSuffix = "}"
        static let textAttachmentPlaceholderAssigner = "="
        static let textAttachmentPlaceholderRegex =
        "\\\(ParserConstants.tAPlaceholderPrefix)\(ParserConstants.textAttachmentPlaceholderAssigner)[0-9]+?\\\(ParserConstants.tAPlaceholderSuffix)"
        static let textAttachmentPlaceholder =
        "\(ParserConstants.tAPlaceholderPrefix)\(ParserConstants.textAttachmentPlaceholderAssigner)%d\(ParserConstants.tAPlaceholderSuffix)"
        typealias RichTextWithErrors = (output: NSAttributedString, errors: [ParsingError]?)
        static let bulletString = "•"
        static let listOpeningHTMLString = "</style></head><body><ul"
        static let listClosingHTMLString = "</ul></body></html>"
        static let latexSubscriptCharacter = "_"
        static let defaultSubScriptOffset: CGFloat = 2.66
        static let bulletCustomAttributeIdentifier = "bullets"
    }

    // MARK: - Dependencies

    let latexParser: LatexParserProtocol
    let font: UIFont
    let textColor: UIColor
    let latexTextBaselineOffset: CGFloat
    let interactiveTextColor: UIColor
    let customAdditionalAttributes: [String: [NSAttributedString.Key: Any]]?

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser(),
         font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
         textColor: UIColor = UIColor.black,
         latexTextBaselineOffset: CGFloat = 0,
         interactiveTextColor: UIColor = UIColor.blue,
         customAdditionalAttributes: [String: [NSAttributedString.Key: Any]]? = nil) {
        self.latexParser = latexParser
        self.font = font
        self.textColor = textColor
        self.latexTextBaselineOffset = latexTextBaselineOffset
        self.interactiveTextColor = interactiveTextColor
        self.customAdditionalAttributes = customAdditionalAttributes
    }

    // MARK: - Multi-Purpose Functions

    func getRichDataTypes(from input: String) -> [RichDataType] {
        if input.isEmpty {
            return [RichDataType.text(richText: NSAttributedString(string: ""), font: self.font, errors: nil)]
        }
        var errors: [ParsingError]?
        return self.splitInputOnVideoPortions(input).compactMap { input -> RichDataType in
            if self.isStringAVideoTag(input) {
                return RichDataType.video(tag: input, error: nil)
            }
            let results = self.getRichTextWithErrors(from: input)
            if errors == nil {
                errors = results.errors
            } else if let resultErrors = results.errors {
                errors?.append(contentsOf: resultErrors)
            }
            return RichDataType.text(richText: results.output, font: self.font, errors: errors)
        }
    }

    func getRichTextWithErrors(from input: String) -> ParserConstants.RichTextWithErrors {
        let input = self.stripCodeTagsIfNecessary(from: input)
        let inputAsMutableAttributedString = NSMutableAttributedString(string: input)
        let richTextWithSpecialDataTypesHandled = self.getRichTextWithSpecialDataTypesHandled(
            fromString: inputAsMutableAttributedString
        )
        let textAttachmentAttributesInRichText = self.extractTextAttachmentAttributesInOrder(fromAttributedString: richTextWithSpecialDataTypesHandled.output)
        let richTextWithHTMLAndMarkdownHandled = self.getRichTextWithHTMLAndMarkdownHandled(
            fromString: self.replaceTextAttachmentsWithPlaceHolderInfo(inAttributedString: richTextWithSpecialDataTypesHandled.output)
        )

        let outputRichText = self.mergeSpecialDataAndHTMLMarkdownAttribute(
            htmlMarkdownString: NSMutableAttributedString(attributedString: richTextWithHTMLAndMarkdownHandled.output),
            specialDataTypesString: richTextWithSpecialDataTypesHandled.output,
            textAttachmentAttributes: textAttachmentAttributesInRichText
        ).trimmingTrailingNewlinesAndWhitespaces()

        outputRichText.replaceFont(with: self.font)
        outputRichText.replaceColor(with: self.textColor)

        if richTextWithSpecialDataTypesHandled.errors == nil, richTextWithHTMLAndMarkdownHandled.errors == nil {
            return (outputRichText, nil)
        }

        let outputErrors = (richTextWithSpecialDataTypesHandled.errors ?? [ParsingError]()) + (richTextWithHTMLAndMarkdownHandled.errors ?? [ParsingError]())
        return (outputRichText, outputErrors)
    }

    private func mergeSpecialDataAndHTMLMarkdownAttribute(htmlMarkdownString: NSMutableAttributedString,
                                                          specialDataTypesString: NSAttributedString,
                                                          textAttachmentAttributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let outputString = self.mergeTextAttachmentsAndHTMLMarkdownAttributes(
            htmlMarkdownString: htmlMarkdownString,
            textAttachmentAttributes: textAttachmentAttributes
        )
        let rangeOfSpecialDataString = NSRange(location: 0, length: specialDataTypesString.length)
        specialDataTypesString.enumerateAttributes(in: rangeOfSpecialDataString) { (attributes, range, _) in
            if attributes.isEmpty || attributes[.attachment] != nil {
                return
            }
            let specialDataSubstring = specialDataTypesString.string[
                max(range.lowerBound, 0)..<min(range.upperBound, specialDataTypesString.string.count)
            ]
            let rangeOfSubstringInOutputString = (outputString.string as NSString).range(of: specialDataSubstring)
            if rangeOfSubstringInOutputString.location == NSNotFound ||
                rangeOfSubstringInOutputString.location < 0 ||
                rangeOfSubstringInOutputString.location + rangeOfSubstringInOutputString.length > outputString.length {
                return
            }
            let newOutuptSubstring = NSMutableAttributedString(attributedString: outputString.attributedSubstring(from: rangeOfSubstringInOutputString))
            newOutuptSubstring.addAttributes(attributes, range: NSRange(location: 0, length: newOutuptSubstring.length))
            newOutuptSubstring.replaceCharacters(in: NSRange(location: 0, length: newOutuptSubstring.length), with: specialDataSubstring)
            outputString.replaceCharacters(in: rangeOfSubstringInOutputString, with: newOutuptSubstring)
        }
        return outputString
    }

    private func mergeTextAttachmentsAndHTMLMarkdownAttributes(htmlMarkdownString: NSMutableAttributedString,
                                                               textAttachmentAttributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let textAttachmentRegex = try? NSRegularExpression(pattern: ParserConstants.textAttachmentPlaceholderRegex, options: [])
        let inputRange = NSRange(location: 0, length: htmlMarkdownString.length)
        guard let textAttachmentMatches = textAttachmentRegex?.matches(in: htmlMarkdownString.string, options: [], range: inputRange) else {
            return htmlMarkdownString
        }

        for match in textAttachmentMatches.reversed() {
            let matchedSubstring = htmlMarkdownString.attributedSubstring(from: match.range).string
            let matchedComponentsSeparatedByAssigner = matchedSubstring.components(
                separatedBy: ParserConstants.textAttachmentPlaceholderAssigner
            )
            let decimalCharacters = CharacterSet.decimalDigits.inverted
            guard let textAttachmentPositionAsSubstring = matchedComponentsSeparatedByAssigner.last?.components(separatedBy: decimalCharacters).joined(),
                let textAttachmentPosition = Int(textAttachmentPositionAsSubstring),
                textAttachmentAttributes.indices.contains(textAttachmentPosition) else {
                    continue
            }
            let textAttachmentAttributes = textAttachmentAttributes[textAttachmentPosition]
            guard let textAttachment = textAttachmentAttributes[.attachment] as? NSTextAttachment else {
                continue
            }
            let textAttachmentAttributedString = NSMutableAttributedString(attachment: textAttachment)
            textAttachmentAttributedString.addAttributes(
                textAttachmentAttributes,
                range: NSRange(location: 0, length: textAttachmentAttributedString.length)
            )
            htmlMarkdownString.replaceCharacters(in: match.range, with: textAttachmentAttributedString)
        }
        return htmlMarkdownString
    }

    // MARK: - Boolean Checkers

    func isTextLatex(_ text: String) -> Bool {
        return !self.getLatexRanges(inText: text).isEmpty
    }

    func isTextInteractiveElement(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.interactiveElementRegex, options: .regularExpression).count != 0
    }

    func isTextHighlightedElement(_ text: String) -> Bool {
        return text.ranges(of: ParserConstants.highlightedElementRegex, options: .regularExpression).count != 0
    }

    private func isStringAVideoTag(_ input: String) -> Bool {
        return input.range(of: RichTextViewConstants.videoTagRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    // MARK: - Video Functions

    private func splitInputOnVideoPortions(_ input: String) -> [String] {
        return input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
    }

    // MARK: - HTML/Markdown Helpers

    private func getRichTextWithHTMLAndMarkdownHandled(fromString mutableAttributedString: NSMutableAttributedString) -> ParserConstants.RichTextWithErrors {
        let inputString = mutableAttributedString.string
        let inputStringWithoutBreakingSpaces = inputString.replaceTrailingWhiteSpaceWithNonBreakingSpace().replaceLeadingWhiteSpaceWithNonBreakingSpace()
        guard let inputAsHTMLString = try? Down(markdownString: inputStringWithoutBreakingSpaces).toHTML([.unsafe, .hardBreaks]),
            let inputAsHTMLWithZeroWidthSpaceRemoved = inputAsHTMLString.replaceAppropiateZeroWidthSpaces(),
            let htmlData = inputAsHTMLWithZeroWidthSpaceRemoved.data(using: .utf8) else {
                return (mutableAttributedString.trimmingTrailingNewlinesAndWhitespaces(), [ParsingError.attributedTextGeneration(text: inputString)])
        }
        let parsedAttributedString = self.getParsedHTMLAttributedString(fromData: htmlData)
        guard let parsedHTMLAttributedString = parsedAttributedString else {
            return (mutableAttributedString.trimmingTrailingNewlinesAndWhitespaces(), [ParsingError.attributedTextGeneration(text: inputString)])
        }
        let parsedMutableAttributedString = NSMutableAttributedString(attributedString: parsedHTMLAttributedString)
        let finalOutputString = self.addCustomStylingToBulletPointsIfNecessary(parsedMutableAttributedString)
        return (finalOutputString, nil)
    }

    private func getParsedHTMLAttributedString(fromData data: Data) -> NSAttributedString? {
        var attributedString: NSAttributedString?
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if Thread.isMainThread {
            attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        } else {
            DispatchQueue.main.sync {
                attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
            }
        }
        return attributedString
    }

    private func addCustomStylingToBulletPointsIfNecessary(_ input: NSMutableAttributedString) -> NSMutableAttributedString {
        guard let customBulletAttributes = self.customAdditionalAttributes?[ParserConstants.bulletCustomAttributeIdentifier],
            let bulletPointRegex = try? NSRegularExpression(pattern: ParserConstants.bulletString, options: []) else {
            return input
        }
        let bulletPointMatches = bulletPointRegex.matches(
            in: input.string,
            options: [],
            range: NSRange(location: 0, length: input.string.count)
        )
        let output = input
        bulletPointMatches.reversed().forEach { match in
            output.addAttributes(customBulletAttributes, range: match.range)
        }
        return output
    }

    private func stripCodeTagsIfNecessary(from input: String) -> String {
        return input.replacingOccurrences(of: "[code]", with: "`").replacingOccurrences(of: "[/code]", with: "`")
    }

    // MARK: - String Helpers

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

    private func extractPositions(fromRanges ranges: [Range<String.Index>]) -> [String.Index] {
        return ranges.flatMap { [$0.lowerBound, $0.upperBound] }.sorted()
    }

    // MARK: - Text Attachment Functions

    private func extractTextAttachmentAttributesInOrder(fromAttributedString input: NSAttributedString) -> [[NSAttributedString.Key: Any]] {
        var output = [[NSAttributedString.Key: Any]]()
        let range = NSRange(location: 0, length: input.length)
        input.enumerateAttributes(in: range, options: [.reverse]) { (attributes, _, _) in
            guard attributes.keys.contains(.attachment) else {
                return
            }
            output.append(attributes)
        }
        return output
    }

    private func replaceTextAttachmentsWithPlaceHolderInfo(inAttributedString input: NSAttributedString) -> NSMutableAttributedString {
        let output = NSMutableAttributedString(attributedString: input)
        let range = NSRange(location: 0, length: input.length)
        var position = 0
        input.enumerateAttributes(in: range, options: [.reverse]) { (attributes, range, _) in
            guard attributes.keys.contains(.attachment) else {
                return
            }
            output.replaceCharacters(in: range, with: String(format: ParserConstants.textAttachmentPlaceholder, position))
            position += 1
        }
        return output
    }

    // MARK: - Special Data Type Helpers

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
            context: nil
        )
        return frame.size.height
    }

    private func getRichTextWithSpecialDataTypesHandled(fromString mutableAttributedString: NSMutableAttributedString) -> ParserConstants.RichTextWithErrors {
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
        return self.mergeSpecialDataComponentsAndReturnRichText(
            self.split(mutableAttributedString: mutableAttributedString, onPositions: splitPositions)
        )
    }

    private func mergeSpecialDataComponentsAndReturnRichText(_ components: [NSAttributedString]) -> ParserConstants.RichTextWithErrors {
        let output = NSMutableAttributedString()
        var parsingErrors: [ParsingError]?
        components.forEach { attributedString in
            if self.isTextInteractiveElement(attributedString.string) {
                output.append(self.extractInteractiveElement(from: attributedString))
                return
            }
            if self.isTextHighlightedElement(attributedString.string) {
                output.append(self.extractHighlightedElement(from: attributedString))
                return
            }
            if self.isTextLatex(attributedString.string) {
                if let attributedLatexString = self.extractLatex(from: attributedString.string) {
                    output.append(attributedLatexString)
                    return
                }
                if parsingErrors == nil {
                    parsingErrors = [ParsingError]()
                }
                output.append(attributedString)
                parsingErrors?.append(ParsingError.latexGeneration(text: attributedString.string))
                return
            }
            output.append(attributedString)
        }
        return (output.trimmingTrailingNewlinesAndWhitespaces(), parsingErrors)
    }

    func extractLatex(from input: String) -> NSAttributedString? {
        return self.latexParser.extractLatex(
            from: input,
            textColor: self.textColor,
            baselineOffset: self.latexTextBaselineOffset,
            fontSize: self.font.pointSize,
            height: self.calculateContentHeight()
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
        guard let richTextAttributes = self.customAdditionalAttributes?[highlightedElementID] else {
            return NSMutableAttributedString(string: highlightedElementText)
        }
        let attributes: [NSAttributedString.Key: Any] = [.highlight: highlightedElementID]
        .merging(input.attributes(at: 0, effectiveRange: nil)) { (current, _) in current }
        .merging(richTextAttributes) { (current, _) in current }
        let mutableAttributedInput = NSMutableAttributedString(string: highlightedElementText, attributes: attributes)
        return mutableAttributedInput
    }
}
