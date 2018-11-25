//
//  ViewController.swift
//  RichTextView-Example
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import UIKit
import THRichTextView

class ViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - Constants

    private enum Views {
        static let subviews: [UIView] = [
            InputOutputModuleView(text: "Here is some LaTeX: [math]x^n[/math]"),
            InputOutputModuleView(text: "# Here is some Markdown:\n`Wow this is great!`"),
            InputOutputModuleView(text: "Here is a YouTube video: youtube[DLzxrzFCyOs]"),
            InputOutputModuleView(text: "<html><p>Here is some HTML</p></html>"),
            InputOutputModuleView(text: "Here is some code: [code]print('Hello World!')[/code]"),
            InputOutputModuleView(text: "Here is a Vimeo video: vimeo[100708006]")
        ]
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
    }

    // MARK: - Private Helpers

    private func setupSubviews() {
        for (index, subview) in Views.subviews.enumerated() {
            self.scrollView.addSubview(subview)
            subview.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(self.scrollView)
                } else {
                    make.top.equalTo(Views.subviews[index - 1].snp.bottom)
                }
                make.width.equalTo(self.scrollView)
                make.centerX.equalTo(self.scrollView)
                if index == Views.subviews.count - 1 {
                    make.bottom.equalTo(self.scrollView)
                }
            }
        }
    }
}
