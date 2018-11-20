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

    func getComponents(separatedBy string: String, options: CompareOptions = .regularExpression) -> [String] {
        var ranges = [Range<Index>]()
        var start = self.startIndex
        while let range = self.range(of: string, options: options, range: start..<self.endIndex) {
            if start != range.lowerBound {
                ranges.append(Range(uncheckedBounds: (lower: start, upper: range.lowerBound)))
            }
            ranges.append(range)

            start = {
                if range.lowerBound < range.upperBound {
                    return range.upperBound
                }
                return self.index(range.lowerBound, offsetBy: 1, limitedBy: self.endIndex) ?? self.endIndex
            }()
        }
        if let lastRange = ranges.last, lastRange.upperBound < self.endIndex {
            ranges.append(Range(uncheckedBounds: (lower: lastRange.upperBound, upper: self.endIndex)))
        }
        if ranges.isEmpty {
            return [self]
        }
        return ranges.map { String(self[$0]) }
    }

    // MARK: - Split String Extensions

    func split(atPositions positions: [Index]) -> [String] {
        var substrings = [String]()
        var start = 0
        while start < positions.count {
            let substring: String = {
                let startIndex = positions[start]
                if startIndex > self.startIndex && substrings.count == 0 {
                    return String(self[..<startIndex])
                }
                if start == positions.count - 1 {
                    start += 1
                    return String(self[startIndex...])
                }
                let endIndex = positions[start + 1]
                start += 1
                return String(self[startIndex..<endIndex])
            }()
            if !substring.isEmpty {
                substrings.append(substring)
            }
        }
        return substrings
    }

    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result = [Range<Index>]()
        var start = self.startIndex
        while let range = self.range(of: string, options: options, range: start..<self.endIndex) {
            result.append(range)
            start = {
                if range.lowerBound < range.upperBound {
                    return range.upperBound
                }
                return self.index(range.lowerBound, offsetBy: 1, limitedBy: self.endIndex) ?? self.endIndex
            }()
        }
        return result
    }
}
