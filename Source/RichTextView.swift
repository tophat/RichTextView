//
//  RichTextView.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import SnapKit

public class RichTextView: UIView {

    // MARK: - Properties

    private(set) var input: String
    private(set) var richTextParser: RichTextParser
    private(set) var textColor: UIColor

    // MARK: - Init

    public init(input: String = "",
                latexParser: LatexParserProtocol = LatexParser(),
                font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
                textColor: UIColor = UIColor.black,
                frame: CGRect) {
        self.input = input
        self.richTextParser = RichTextParser(latexParser: latexParser, font: font, textColor: textColor)
        self.textColor = textColor
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        self.input = ""
        self.richTextParser = RichTextParser()
        self.textColor = UIColor.black
        super.init(coder: aDecoder)
        self.setupSubviews()
    }

    // MARK: - Helpers

    public func update(input: String? = nil, latexParser: LatexParserProtocol? = nil, font: UIFont? = nil, textColor: UIColor? = nil) {
        self.input = input ?? self.input
        self.richTextParser = RichTextParser(
            latexParser: latexParser ?? self.richTextParser.latexParser,
            font: font ?? self.richTextParser.font,
            textColor: textColor ?? self.textColor
        )
        self.textColor = textColor ?? self.textColor
        self.subviews.forEach { $0.removeFromSuperview() }
        self.setupSubviews()
    }

    private func setupSubviews() {
        let subviews = self.generateViews(from: self.input)
        for (index, subview) in subviews.enumerated() {
            self.addSubview(subview)
            subview.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(self)
                } else {
                    make.top.equalTo(subviews[index - 1].snp.bottom)
                }
                make.width.equalTo(self)
                make.centerX.equalTo(self)
                if index == subviews.count - 1 {
                    make.bottom.equalTo(self)
                }
            }
        }
    }

    func generateViews(from input: String) -> [UIView] {
        return self.richTextParser.getRichDataTypes(from: input).compactMap { (richDataType: RichDataType) -> UIView? in
            switch richDataType {
            case .video(let tag):
                return RichWebViewGenerator.getWebView(from: tag)
            case .text(let richText, let font):
                return RichLabelGenerator.getLabel(from: richText, font: font, textColor: textColor)
            }
        }
    }
}
