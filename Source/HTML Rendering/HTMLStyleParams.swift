//
//  HTMLStyleParams.swift
//  
//
//  Created by Maicon Brauwers on 2022-02-24.
//

import UIKit

public struct HTMLStyleParams: Hashable {
    let baseFont: UIFont
    let h1Font: UIFont
    let h2Font: UIFont
    let h3Font: UIFont

    public init(baseFont: UIFont, h1Font: UIFont, h2Font: UIFont, h3Font: UIFont) {
        self.baseFont = baseFont
        self.h1Font = h1Font
        self.h2Font = h2Font
        self.h3Font = h3Font
    }
}
