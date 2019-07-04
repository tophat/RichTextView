//
//  UIColorExtension.swift
//  RichTextView
//
//  Created by Simon Chau on 2019-07-03.
//  Copyright © 2019 Top Hat. All rights reserved.
//

extension UIColor {
    static func == (leftColor: UIColor, rightColor: UIColor) -> Bool {
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0
        leftColor.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0
        rightColor.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        return red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2
    }
}

func == (leftColor: UIColor?, rightColor: UIColor?) -> Bool {
    guard let leftColor = leftColor, let rightColor = rightColor else {
        return false
    }
    return leftColor == rightColor
}
