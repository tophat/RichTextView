//
//  RichTextView.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import SnapKit
import WebKit

public class RichTextView: UIView {

    // MARK: - Properties

    public private(set) var input: String
    private(set) var richTextParser: RichTextParser
    private(set) var textColor: UIColor
    private(set) var isSelectable: Bool
    private(set) var isEditable: Bool

    private(set) var errors: [ParsingError]?

    // MARK: - Constants

    private enum VideoProperties {
        static let defaultAspectRatio = 9.0/16.0
    }

    // MARK: - Init

    public init(input: String = "",
                latexParser: LatexParserProtocol = LatexParser(),
                font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
                textColor: UIColor = UIColor.black,
                isSelectable: Bool = true,
                isEditable: Bool = false,
                latexTextBaselineOffset: CGFloat = 0,
                frame: CGRect,
                completion: (([ParsingError]?) -> Void)? = nil) {
        self.input = input
        self.isSelectable = isSelectable
        self.isEditable = isEditable
        self.richTextParser = RichTextParser(latexParser: latexParser, font: font, textColor: textColor, latexTextBaselineOffset: latexTextBaselineOffset)
        self.textColor = textColor
        super.init(frame: frame)
        self.setupSubviews()
        completion?(self.errors)
    }

    required init?(coder aDecoder: NSCoder) {
        self.input = ""
        self.richTextParser = RichTextParser()
        self.textColor = UIColor.black
        self.isSelectable = true
        self.isEditable = false
        super.init(coder: aDecoder)
        self.setupSubviews()
    }

    // MARK: - Helpers

    public func update(input: String? = nil,
                       latexParser: LatexParserProtocol? = nil,
                       font: UIFont? = nil,
                       textColor: UIColor? = nil,
                       latexTextBaselineOffset: CGFloat? = nil,
                       completion: (([ParsingError]?) -> Void)? = nil) {
        self.input = input ?? self.input
        self.richTextParser = RichTextParser(
            latexParser: latexParser ?? self.richTextParser.latexParser,
            font: font ?? self.richTextParser.font,
            textColor: textColor ?? self.textColor,
            latexTextBaselineOffset: latexTextBaselineOffset ?? self.richTextParser.latexTextBaselineOffset
        )
        self.textColor = textColor ?? self.textColor
        self.subviews.forEach { $0.removeFromSuperview() }
        self.setupSubviews()
        completion?(self.errors)
    }

    private func setupSubviews() {
        let subviews = self.generateViews()
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
                if subview is WKWebView {
                    make.height.equalTo(self.snp.width).multipliedBy(VideoProperties.defaultAspectRatio)
                }
                if index == subviews.count - 1 {
                    make.bottom.equalTo(self)
                }
            }
        }
    }

    func generateViews() -> [UIView] {
        return self.richTextParser.getRichDataTypes(from: self.input).compactMap { (richDataType: RichDataType) -> UIView? in
            switch richDataType {
            case .video(let tag, let error):
                self.appendError(error)
                let webView = WKWebViewGenerator.getWebView(from: tag)
                if webView == nil {
                    self.appendError(ParsingError.webViewGeneration(link: tag))
                }
                return webView
            case .text(let richText, let font, let errors):
                self.appendErrors(errors)
                return UITextViewGenerator.getTextView(
                    from: richText,
                    font: font,
                    textColor: textColor,
                    isSelectable: self.isSelectable,
                    isEditable: self.isEditable
                )
            }
        }
    }

    private func appendErrors(_ errors: [ParsingError]?) {
        if let errors = errors {
            if self.errors == nil {
                self.errors = [ParsingError]()
            }
            self.errors?.append(contentsOf: errors)
        }
    }

    private func appendError(_ error: ParsingError?) {
        if let error = error {
            if self.errors == nil {
                self.errors = [ParsingError]()
            }
            self.errors?.append(error)
        }
    }
}
