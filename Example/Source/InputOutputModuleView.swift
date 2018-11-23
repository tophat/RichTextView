//
//  InputOutputModuleView.swift
//  RichTextView-Example
//
//  Created by Ahmed Elkady on 2018-11-23.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import THRichTextView
import UIKit

class InputOutputModuleView: UIView {

    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var outputRichTextView: RichTextView!

    // MARK: - Init

    init(text: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setupWithNib()
        self.updateText(text)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupWithNib()
    }

    // MARK: - Private Helpers

    private func setupWithNib() {
        Bundle.main.loadNibNamed("InputOutputModuleView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func updateText(_ text: String) {
        self.inputLabel.text = text
        self.outputRichTextView.update(input: text)
    }
}
