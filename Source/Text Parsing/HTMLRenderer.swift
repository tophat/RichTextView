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
        }

        let boldStyle = Style {
            $0.font = styleParams.boldFont
        }
        
        /*
        let brStyle = Style {
            $0.font = styleParams.baseFont
            $0.textTransforms = [
                .custom { "\n" + $0 }
            ]
        }*/
        
        return StyleXML(
            base: baseStyle,
            ["p": baseStyle, "div": baseStyle, "h1": h1Style, "h2": h2Style, "h3": h3Style, "i": italicStyle, "em": italicStyle, "bold": boldStyle, "strong": boldStyle]
        )
    }

}
