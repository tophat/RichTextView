//
//  HTMLRenderer.swift
//  
//
//  Created by Maicon Brauwers on 2022-02-22.
//

import UIKit
import SwiftRichString

/*
 * Renders an HTML string into a NSAttributedString by using the SwiftRichString dependency
 */

class HTMLRenderer {
    
    var cachedStyles: [HTMLStyleParams: StyleXML] = [:]
    static let shared = HTMLRenderer()
    
    func renderHTML(html: String, styleParams: HTMLStyleParams) -> NSAttributedString {
        print("renderHTML \(html)")
        if self.cachedStyles[styleParams] == nil {
            print("needs to build styles")
            self.cachedStyles[styleParams] = StyleBuilder().buildStyles(styleParams: styleParams)
        }
        guard let style = cachedStyles[styleParams] else {
            print("ooops no  style.....")
            return NSAttributedString()
        }
        let htmlReplacingBr = html.replacingOccurrences(of: "<br>", with: "\n")
        return htmlReplacingBr.set(style: style)
    }
}



struct StyleBuilder {
    
    func buildStyles(styleParams: HTMLStyleParams) -> StyleGroup {

        let baseStyle = Style {
            $0.font = styleParams.baseFont
        }
        
        let h1Style = Style {
            $0.font = styleParams.h1Font
        }

        let h2Style = Style {
            $0.font = styleParams.h2Font
        }

        let h3Style = Style {
            $0.font = styleParams.h3Font
        }

        let italicStyle = baseStyle.byAdding {
            $0.traitVariants = .italic
        }

        let boldStyle = baseStyle.byAdding {
            $0.traitVariants = .bold
        }
        
        let superStyle = Style {
            $0.font = styleParams.baseFont.font(size: 12.0)
            $0.baselineOffset = 20.0 / 3.5
        }

        let subStyle = baseStyle.byAdding {
            $0.font = styleParams.baseFont.font(size: 12.0)
            $0.baselineOffset = -20.0 / 3.5
        }
        
        let codeStyle = baseStyle.byAdding {
            $0.font = styleParams.baseFont.font(size: 18.0)
            $0.backColor = Color(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
            $0.lineSpacing = 21
            $0.color = Color(red: 0.69, green: 0.231, blue: 0, alpha: 1)
        }
        
        let groupStyle = StyleXML(
            base: baseStyle,
            ["p": baseStyle, "div": baseStyle, "h1": h1Style, "h2": h2Style, "h3": h3Style, "i": italicStyle, "em": italicStyle, "italic": italicStyle, "bold": boldStyle, "strong": boldStyle, "b": boldStyle, "sub": subStyle, "sup": superStyle, "span": baseStyle, "code": codeStyle]
        )
        groupStyle.xmlAttributesResolver = DynamicAttributesResolver()
        return groupStyle
    }
}

// First define our own resolver for attributes
class DynamicAttributesResolver: XMLDynamicAttributesResolver {
    
    func styleForUnknownXMLTag(_ tag: String, to attributedString: inout SwiftRichString.AttributedString, attributes: [String : String]?, fromStyle: StyleXML) {
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
                    var substr = value.suffix(from: "color: rgb(".endIndex)
                    substr = substr.dropLast()
                    let rgbValues = substr.split(separator: ",")
                    if rgbValues.count == 3, let red = Float(rgbValues[0].trimmingCharacters(in: .whitespacesAndNewlines)), let green = Float(rgbValues[1].trimmingCharacters(in: .whitespacesAndNewlines)), let blue = Float(rgbValues[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
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
