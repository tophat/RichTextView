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

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser()) {
        self.latexParser = latexParser
    }

    func richTextToAttributedString(from input: String) -> NSAttributedString {
        let components = self.seperateComponents(from: input)
        let attributedArray = self.generateAttributedStringArray(from: components)
        let mutableAttributedString = NSMutableAttributedString()
        for attributedString in attributedArray {
            mutableAttributedString.append(attributedString)
        }
        return mutableAttributedString
    }

    // MARK: - Helpers

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
        return try? Down(markdownString: input).toAttributedString()
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
}
