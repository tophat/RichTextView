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

    init(latexParser: LatexParserProtocol = LatexParser.shared) {
        self.latexParser = latexParser
    }

    // MARK: - Helpers

    func extractLatex(from input: String) -> NSAttributedString {
        return self.latexParser.extractLatex(from: input)
    }
}
