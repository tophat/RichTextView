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
        let style: StyleXML

        if let cachedStyle = self.cachedStyles[styleParams] {
            style = cachedStyle
        } else {
            style = HTMLStyleBuilder().buildStyles(styleParams: styleParams)
            cachedStyles[styleParams] = style
        }
        
        let htmlReplacingBr = html.replacingOccurrences(of: "<br>", with: "\n")
        return htmlReplacingBr.set(style: style)
    }
}
