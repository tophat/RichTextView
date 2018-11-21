//
//  ParsingError.swift
//  RichTextView
//
//  Created by Orla Mitchell on 2018-11-21.
//  Copyright © 2018 Top Hat. All rights reserved.
//

public enum ParsingError: LocalizedError {
    case attributedTextGeneration(text: String)
    case webViewGeneration(link: String)
    case latexGeneration(text: String)

    public var errorDescription: String? {
        switch self {
        case let .attributedTextGeneration(text):
            return "Error Generating Attributed Text: " + text
        case let .webViewGeneration(link):
            return "Error Generating Webview: " + link
        case let .latexGeneration(text):
            return "Error Generating Latex: " + text
        }
    }
}
