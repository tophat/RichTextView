//
//  UIColorExtension.swift
//  RichTextView
//
//  Created by Simon Chau on 2019-07-03.
//  Copyright © 2019 Top Hat. All rights reserved.
//

extension UIColor {
    static func == (leftColor: UIColor, rightColor: UIColor) -> Bool {
        var leftRed: CGFloat = 0
        var leftGreen: CGFloat = 0
        var leftblue: CGFloat = 0
        var leftAlpha: CGFloat = 0
        leftColor.getRed(&leftRed, green: &leftGreen, blue: &leftblue, alpha: &leftAlpha)
        var rightRed: CGFloat = 0
        var rightGreen: CGFloat = 0
        var rightBlue: CGFloat = 0
        var rightAlpha: CGFloat = 0
        rightColor.getRed(&rightRed, green: &rightGreen, blue: &rightBlue, alpha: &rightAlpha)
        return leftRed == rightRed && leftGreen == rightGreen && leftblue == rightBlue && leftAlpha == rightAlpha
    }
}

func == (leftColor: UIColor?, rightColor: UIColor?) -> Bool {
    guard let leftColor = leftColor, let rightColor = rightColor else {
        return false
    }
    return leftColor == rightColor
}
