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

    init(input: String = "", latexParser: LatexParserProtocol = LatexParser(), frame: CGRect) {
        self.input = input
        self.latexParser = latexParser
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.input = ""
        self.latexParser = LatexParser()
        super.init(coder: aDecoder)
    }

    // MARK: - Private Helpers

    private func generateArrayOfLabelsAndWebviews() -> [UIView] {
        return self.splitInputOnVideoPortions().compactMap { input -> UIView? in
            return self.isStringAVideoTag(input) ? RichWebViewGenerator.getWebView(from: input) : RichLabelGenerator.getLabel(from: input)
        }
    }

    private func splitInputOnVideoPortions() -> [String] {
        return self.input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
    }

    private func isStringAVideoTag(_ input: String) -> Bool {
        return input.range(of: RichTextViewConstants.videoTagRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
