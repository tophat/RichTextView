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

struct HTMLRenderer {
    
    func renderHTML(html: String, styleParams: StyleBuilder.StyleParams) -> NSAttributedString {
        print("renderHTML \(html)")
        let html2 = html.replacingOccurrences(of: "<br>", with: "\n")
        let style = StyleBuilder().buildStyles(styleParams: styleParams)
        return html2.set(style: style)
    }
    
}

struct StyleBuilder {

    struct StyleParams {
        let baseFont: UIFont
        let h1Font: UIFont
        let h2Font: UIFont
        let h3Font: UIFont
        let italicsFont: UIFont
        let boldFont: UIFont
    }
    
    func buildStyles(styleParams: StyleParams) -> StyleGroup {

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

        let italicStyle = Style {
            $0.font = styleParams.italicsFont
//            $0.size = 20
//            $0.traitVariants = .italic
            /*
            $0.font = styleParams.baseFont
            if $0.traitVariants == nil {
                $0.traitVariants = TraitVariant()
            }
            $0.traitVariants?.update(with: .italic)*/
        }

        let boldStyle = Style {
            $0.font = styleParams.baseFont
//            $0.size = 20
            $0.traitVariants = [.bold, .italic]
//            $0.traitVariants = [.bold]
            /*
            if $0.traitVariants == nil {
                $0.traitVariants = TraitVariant()
            }
            $0.traitVariants?.update(with: .bold)*/
        }
        
        let superStyle = Style {
            $0.font = styleParams.baseFont.font(size: 14.0)
            $0.baselineOffset = 20.0 / 3.5
        }

        let subStyle = baseStyle.byAdding {
            $0.font = styleParams.baseFont.font(size: 14.0)
            $0.baselineOffset = -20.0 / 3.5
        }
        
        let groupStyle = StyleXML(
            base: baseStyle,
            ["p": baseStyle, "div": baseStyle, "h1": h1Style, "h2": h2Style, "h3": h3Style, "i": italicStyle, "em": italicStyle, "italic": italicStyle, "bold": boldStyle, "strong": boldStyle, "b": boldStyle, "sub": subStyle, "sup": superStyle, "span": baseStyle]
        )
        groupStyle.xmlAttributesResolver = DynamicAttributesResolver()
        return groupStyle
    }

}

// First define our own resolver for attributes
class DynamicAttributesResolver: XMLDynamicAttributesResolver {
    
    func styleForUnknownXMLTag(_ tag: String, to attributedString: inout SwiftRichString.AttributedString, attributes: [String : String]?, fromStyle: StyleXML) {
        /*
        print("styleForUnknownXMLTag \(tag) \(attributedString) \(String(describing: attributes)) \(fromStyle.styles)")
        if let style = fromStyle.styles["bold"] {
            print("yes, we got bold")
//            attributedString.add(style: style, range: nil)
            let descriptor = UIFont.systemFont(ofSize: 20).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic])!
            let font = UIFont(descriptor: descriptor, size: 20.0)
            attributedString.setAttributes([.font: font], range: NSRange(location: 0, length: attributedString.length))
        }*/
    }
    
    func applyDynamicAttributes(to attributedString: inout SwiftRichString.AttributedString, xmlStyle: XMLDynamicStyle, fromStyle: StyleXML) {
        let finalStyleToApply = Style()
        xmlStyle.enumerateAttributes { key, value  in
            print("key is \(key) value is \(value)")
            switch key {
            case "color": // color support
                print("color value is \(value)")
                finalStyleToApply.color = Color(hexString: value)
            case "style":
                print("style is \(value)")
                if value.starts(with: "color: rgb(") {
                    print("it starts with color rgb")
                    
                    var substr = value.suffix(from: "color: rgb(".endIndex)
                    substr = substr.dropLast()
                    
                    print("substr is \(substr)")
                    
                    let rgbValues = substr.split(separator: ",")
                    print("rgbValues are \(rgbValues)")
                    if rgbValues.count == 3, let red = Float(rgbValues[0].trimmingCharacters(in: .whitespacesAndNewlines)), let green = Float(rgbValues[1].trimmingCharacters(in: .whitespacesAndNewlines)), let blue = Float(rgbValues[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
                        print("here \(red) \(green) \(blue)")
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
