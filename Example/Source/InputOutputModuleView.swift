//
//  InputOutputModuleView.swift
//  RichTextView-Example
//
//  Created by Ahmed Elkady on 2018-11-23.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import RichTextView
import UIKit

class InputOutputModuleView: UIView, RichTextViewDelegate {

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
        self.outputRichTextView.textViewDelegate = self
        self.outputRichTextView.update(input: text)
    }

    // MARK: - RichTextViewDelegate

    func didTapCustomLink(withText linkText: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Custom Link", message: linkText, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
        }
    }
}
