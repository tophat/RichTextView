//
//  ParsingError.swift
//  RichTextView
//
//  Created by Orla Mitchell on 2018-11-21.
//  Copyright © 2018 Top Hat. All rights reserved.
//

public enum ParsingErrorCodes {
    case attributedTextGeneration
}

public struct ParsingError: LocalizedError {
    var title: String?
    var code: ParsingErrorCodes
}
