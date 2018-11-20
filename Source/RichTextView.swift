//
//  RichTextView.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

public class RichTextView: UIView {

    // MARK: - Properties

    private let input: String
    private let latexParser: LatexParserProtocol

    // MARK: - Init

    public init(input: String = "", latexParser: LatexParserProtocol = LatexParser(), frame: CGRect) {
        self.input = input
        self.latexParser = latexParser
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.input = ""
        self.latexParser = LatexParser()
        super.init(coder: aDecoder)
    }
}
