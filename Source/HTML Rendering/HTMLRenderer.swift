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
        if self.cachedStyles[styleParams] == nil {
            self.cachedStyles[styleParams] = StyleBuilder().buildStyles(styleParams: styleParams)
        }
        guard let style = cachedStyles[styleParams] else {
            return NSAttributedString()
        }
        let htmlReplacingBr = html.replacingOccurrences(of: "<br>", with: "\n")
        return htmlReplacingBr.set(style: style)
    }
}
