//
//  LatexParserProtocol.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Down
import iosMath

protocol LatexParserProtocol: class {
    func extractLatex(from input: String) -> NSAttributedString
}

extension LatexParserProtocol {
    func extractLatex(from input: String) -> NSAttributedString {

        let latexInput = self.extractLatexStringInsideTags(from: input)

        let label = MTMathUILabel()
        label.latex = latexInput

        var newFrame = label.frame
        newFrame.size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.frame = newFrame

        guard let image = self.image(from: label) else {
            return NSAttributedString(string: latexInput)
        }

        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        return NSAttributedString(attachment: textAttachment)
    }

    // MARK: - Helpers

    private func extractLatexStringInsideTags(from input: String) -> String {
        return (input.range(of: "[math]")?.upperBound).flatMap { substringFrom in
            (input.range(of: "[/math]", range: substringFrom..<input.endIndex)?.lowerBound).map { substringTo in
                String(input[substringFrom..<substringTo])
            }
        } ?? input
    }

    private func image(from label: MTMathUILabel) -> UIImage? {
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

class LatexParser: LatexParserProtocol {

    // MARK: - Singleton

    static let shared = LatexParser()

    private init() {}
}
