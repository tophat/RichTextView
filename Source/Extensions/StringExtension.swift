//
//  StringExtensions.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

extension String {
    func getSubstring(inBetween firstTag: String, and secondTag: String) -> String? {
        return (self.range(of: firstTag)?.upperBound).flatMap { substringFrom in
            (self.range(of: secondTag, range: substringFrom..<self.endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
