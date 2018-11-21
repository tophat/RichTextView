//
//  ParsingError.swift
//  RichTextView
//
//  Created by Orla Mitchell on 2018-11-21.
//  Copyright © 2018 Top Hat. All rights reserved.
//

public enum ParsingError: LocalizedError {
    case attributedTextGeneration(title: String)

    public var errorDescription: String? {
        switch self {
        case let .attributedTextGeneration(title):
            return "Error Generating Attributed Text: " + title
        }
    }
}
