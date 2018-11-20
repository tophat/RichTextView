//
//  RichDataType.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-20.
//  Copyright © 2018 Top Hat. All rights reserved.
//

enum RichDataType {
    case video(tag: String)
    case text(richText: NSAttributedString, font: UIFont)
}
