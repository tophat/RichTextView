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
    private let richTextParser: RichTextParser

    // MARK: - Init

    public init(input: String = "", latexParser: LatexParserProtocol = LatexParser(), frame: CGRect) {
        self.input = input
        self.richTextParser = RichTextParser(latexParser: latexParser)
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.input = ""
        self.richTextParser = RichTextParser(latexParser: LatexParser())
        super.init(coder: aDecoder)
    }

    // MARK: - Helpers

    func generateArrayOfLabelsAndWebviews(from input: String) -> [UIView] {
        return self.richTextParser.getRichDataTypes(from: input).compactMap { (richDataType: RichDataType) -> UIView? in
            switch richDataType {
            case .video(let tag):
                return RichWebViewGenerator.getWebView(from: tag)
            case .text(let richText):
                return RichLabelGenerator.getLabel(from: richText)
            }
        }
    }
}
