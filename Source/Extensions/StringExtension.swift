//
//  StringExtensions.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

extension String {
    func replaceAppropiateZeroWidthSpaces() -> String? {
        let newString = self
        let cleanString = newString.replacingOccurrences(of: "\u{200B}", with: "\u{200D}")
        return cleanString
    }
    func replaceTrailingWhiteSpaceWithNonBreakingSpace() -> String {
        var newString = self
        while newString.last?.isWhitespace == true {
            newString = String(newString.dropLast())
            newString = newString.replacingCharacters(in: newString.endIndex..., with: "&nbsp;")
        }
        return newString
    }

    func replaceLeadingWhiteSpaceWithNonBreakingSpace() -> String {
        var newString = self
        while newString.first?.isWhitespace == true {
            newString = newString.replacingCharacters(in: ...newString.startIndex, with: "&nbsp;")
        }
        return newString
    }

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

    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript(bounds: CountableRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    subscript(_ index: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: index)
        return String(self[index])
    }

    // MARK: - Split String Extensions

    func split(atPositions positions: [Index]) -> [String] {
        var substrings = [String]()
        var start = 0
        var positions = positions
        positions.sort()
        positions = positions.filter { return $0 > self.startIndex && $0 < self.endIndex }
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
        if substrings.isEmpty {
            return [self]
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
