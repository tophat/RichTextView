//
//  DynamicAttributesResolver.swift
//  
//
//  Created by Maicon Brauwers on 2022-02-24.
//

import UIKit
import SwiftRichString

class DynamicAttributesResolver: XMLDynamicAttributesResolver {

    func styleForUnknownXMLTag(_ tag: String, to attributedString: inout SwiftRichString.AttributedString, attributes: [String: String]?, fromStyle: StyleXML) {
    }

    func applyDynamicAttributes(to attributedString: inout SwiftRichString.AttributedString, xmlStyle: XMLDynamicStyle, fromStyle: StyleXML) {
        let finalStyleToApply = Style()
        xmlStyle.enumerateAttributes { key, value  in
            switch key {
            case "color": // color support
                finalStyleToApply.color = Color(hexString: value)
            case "style":
                // THIS IS ALL HORRIBLE AND SHOULD BE REFACTOR USING A STRING SCANNER OR REGEX!!!
                if value.starts(with: "color: rgb(") {
                    let substr = value.suffix(from: "color: rgb(".endIndex).dropLast()
                    let rgbValues = substr.split(separator: ",")
                    if rgbValues.count == 3,
                       let red = Float(rgbValues[0].trimmingCharacters(in: .whitespacesAndNewlines)),
                       let green = Float(rgbValues[1].trimmingCharacters(in: .whitespacesAndNewlines)),
                       let blue = Float(rgbValues[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
                        finalStyleToApply.color = Color(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
                    }
                }

            default:
                break
            }
        }

        attributedString.add(style: finalStyleToApply)
    }
}
