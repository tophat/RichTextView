//
//  ViewController.swift
//  RichTextView-Example
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - Constants

    private enum Text {
        static let tableHTML = """
        <table>
            <tbody>
                <tr>
                    <th scope="col"><p>1</p></th>
                    <th scope="col"><p>2</p></th>
                    <th scope="col"><p>3</p></th>
                </tr>
                <tr>
                    <td><p>4</p></td>
                    <td><p>5</p></td>
                    <td><p>6</p></td>
                </tr>
                <tr>
                    <td><p>7</p></td>
                    <td><p>8</p></td>
                    <td><p>9</p></td>
                </tr>
            </tbody>
        </table>
        """
    }

    private enum Views {
        static let subviews: [UIView] = [
            InputOutputModuleView(text: "Here is some LaTeX: [math]x^n[/math]"),
            InputOutputModuleView(text: "# Here is some Markdown:\n`Wow this is great!`"),
            InputOutputModuleView(text: "Here is a YouTube video: youtube[DLzxrzFCyOs]"),
            InputOutputModuleView(text: "<html><p>Here is some HTML</p></html>"),
            InputOutputModuleView(text: "Here is some code: [code]print('Hello World!')[/code]"),
            InputOutputModuleView(text: "Here is a Vimeo video: vimeo[100708006]"),
            InputOutputModuleView(text: "<a href='https://www.google.com'>jump to page</a>"),
            InputOutputModuleView(text: Text.tableHTML),
            InputOutputModuleView(text: "<blockquote>Here is a blockquote</blockquote>"),
            InputOutputModuleView(text: "Look [interactive-element id = 123]This is an interactive element[/interactive-element] Wow")
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
