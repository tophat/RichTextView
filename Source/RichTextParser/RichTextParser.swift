//
//  RichTextParser.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

class RichTextParser {
    func isTextHTML(_ text: String) -> Bool {
        do {
            let regexPattern = "(?:</[^<]+>)|(?:<[^<]+/>)"
            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            return regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.count)) != 0
        } catch {
            return false
        }
    }
}
