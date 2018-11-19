//
//  RichTextParser.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

class RichTextParser {

    // MARK: - Dependencies

    let latexParser: LatexParserProtocol

    // MARK: - Init

    init(latexParser: LatexParserProtocol = LatexParser()) {
        self.latexParser = latexParser
    }

    // MARK: - Helpers

    func extractLatex(from input: String) -> NSAttributedString {
        return self.latexParser.extractLatex(from: input)
    }

    func isTextHTML(_ text: String) -> Bool {
        do {
            let regexPattern = "(?:</[^<]+>)|(?:<[^<]+/>)"
            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            return regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.count)) != 0
        } catch {
            return false
        }
    }
}
