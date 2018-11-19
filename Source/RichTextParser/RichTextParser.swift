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

    // MARK: - Helpers

    func generateAttributedStringArray(from input: [String]) -> [NSAttributedString] {
        var output = [NSAttributedString]()
        for element in input {
            if let attributedString = self.getAttributedText(from: element) {
                output.append(attributedString)
            } else {
                // TODO: Add error handling
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
        return input.split(
            atPositions: splitPositions
        )
    }

    func extractLatex(from input: String) -> NSAttributedString {
        return self.latexParser.extractLatex(from: input)
    }

    func isTextLatex(_ text: String) -> Bool {
        return text.contains("[math]")
    }

    private func extractPositions(fromRanges ranges: [Range<String.Index>]) -> [String.Index] {
        return ranges.flatMap { range in
            return [range.lowerBound, range.upperBound]
        }.sorted()
    }
}
