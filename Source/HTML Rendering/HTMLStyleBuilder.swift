//
//  HTMLStyleBuilder.swift
//  
//
//  Created by Maicon Brauwers on 2022-02-24.
//

import SwiftRichString

// This class is responsible to create the styles that are using to style the HTML tags

struct HTMLStyleBuilder {

    // swiftlint:disable function_body_length
    func buildStyles(styleParams: HTMLStyleParams) -> StyleGroup {

        let baseStyle = Style {
            $0.font = styleParams.baseFont
            $0.minimumLineHeight = 28
        }

        let h1Style = Style {
            $0.font = styleParams.h1Font
            $0.traitVariants = .bold
        }

        let h2Style = Style {
            $0.font = styleParams.h2Font
            $0.traitVariants = .bold
        }

        let h3Style = Style {
            $0.font = styleParams.h3Font
            $0.traitVariants = .bold
        }

        let italicStyle = baseStyle.byAdding {
            $0.traitVariants = .italic
        }

        let boldStyle = baseStyle.byAdding {
            $0.traitVariants = .bold
        }

        let superStyle = Style {
            $0.font = styleParams.baseFont.font(size: 8.0)
            $0.baselineOffset = 20.0 / 3.5
        }

        let subStyle = baseStyle.byAdding {
            $0.font = styleParams.baseFont.font(size: 8.0)
            $0.baselineOffset = -20.0 / 3.5
        }

        let codeStyle = baseStyle.byAdding {
            $0.backColor = Color(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
            $0.color = Color(red: 0.69, green: 0.231, blue: 0, alpha: 1)
        }

        let groupStyle = StyleXML(
            base: baseStyle,
            [
                "p": baseStyle,
                "div": baseStyle,
                "h1": h1Style,
                "h2": h2Style,
                "h3": h3Style,
                "i": italicStyle,
                "em": italicStyle,
                "italic": italicStyle,
                "bold": boldStyle,
                "strong": boldStyle,
                "b": boldStyle,
                "sub": subStyle,
                "sup": superStyle,
                "span": baseStyle,
                "code": codeStyle
            ]
        )
        groupStyle.xmlAttributesResolver = DynamicAttributesResolver()
        return groupStyle
    }
    // swiftlint:enable function_body_length
}
