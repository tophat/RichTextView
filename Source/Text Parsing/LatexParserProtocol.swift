//
//  LatexParserProtocol.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Down
import iosMath

public protocol LatexParserProtocol: class {
    func extractLatex(from input: String, textColor: UIColor, baselineOffset: CGFloat, fontSize: CGFloat) -> NSAttributedString?
}

extension LatexParserProtocol {
    public func extractLatex(from input: String, textColor: UIColor, baselineOffset: CGFloat, fontSize: CGFloat) -> NSAttributedString? {

        let latexInput = self.extractLatexStringInsideTags(from: input)
        var mathImage: UIImage?

        if Thread.isMainThread {
            mathImage = self.setupMathLabelAndGetImage(from: latexInput, textColor: textColor, fontSize: fontSize)
        } else {
            DispatchQueue.main.sync {
                mathImage = self.setupMathLabelAndGetImage(from: latexInput, textColor: textColor, fontSize: fontSize)
            }
        }

        guard let image = mathImage else {
            return nil
        }

        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let latexString = NSMutableAttributedString(attachment: textAttachment)
        latexString.addAttribute(.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: latexString.length))
        return latexString
    }

    // MARK: - Helpers

    public func extractLatexStringInsideTags(from input: String) -> String {
        let mathTagName = RichTextParser.ParserConstants.mathTagName
        return input.getSubstring(inBetween: "[\(mathTagName)]", and: "[/\(mathTagName)]") ?? input
    }

    private func setupMathLabelAndGetImage(from input: String, textColor: UIColor, fontSize: CGFloat) -> UIImage? {
        let label = MTMathUILabel()
        label.textColor = textColor
        label.latex = input
        label.fontSize = fontSize

        var newFrame = label.frame
        newFrame.size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.frame = newFrame
        return self.getImage(from: label)
    }

    private func getImage(from label: MTMathUILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let verticalFlip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: label.frame.size.height)
        context.concatenate(verticalFlip)
        label.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
            return nil
        }
        UIGraphicsEndImageContext()
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
}

public class LatexParser: LatexParserProtocol {
    public init() {}
}
