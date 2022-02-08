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
        <html>
            <head>
                <style>
                    table { width: 60%; text-align: center }
                    th { height: 100%; background-color: green }
                    td { height: 100%; background-color: lightblue }
                </style>
            </head>
            <body>
                <table>
                    <thead>
                        <tr>
                            <th scope="col"><p>1</p></th>
                            <th scope="col"><p>2</p></th>
                            <th scope="col"><p>3</p></th>
                        </tr>
                    </thead>
                    <tbody>
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
                        <tr>
                            <td><p>10</p></td>
                            <td><p>11</p></td>
                            <td><p>12</p></td>
                        </tr>
                        <tr>
                            <td><p>13</p></td>
                            <td><p>14</p></td>
                            <td><p>15</p></td>
                        </tr>
                        <tr>
                            <td><p>16</p></td>
                            <td><p>17</p></td>
                            <td><p>18</p></td>
                        </tr>
                        <tr>
                            <td><p>19</p></td>
                            <td><p>20</p></td>
                            <td><p>21</p></td>
                        </tr>
                        <tr>
                            <td><p>22</p></td>
                            <td><p>23</p></td>
                            <td><p>24</p></td>
                        </tr>
                        <tr>
                            <td><p>25</p></td>
                            <td><p>26</p></td>
                            <td><p>27</p></td>
                        </tr>
                        <tr>
                            <td><p>28</p></td>
                            <td><p>29</p></td>
                            <td><p>30</p></td>
                        </tr>
                        <tr>
                            <td><p>31</p></td>
                            <td><p>32</p></td>
                            <td><p>33</p></td>
                        </tr>
                    </tbody>
                </table>
            </body>
        </html>
        """
        static let bulletListHTMLWithInteractiveElements = """
        <html>Some bullets with Interactive Elements:
            <ul>
                <li>[interactive-element id=Item 1]Item 1[/interactive-element]</li>
                <li>[interactive-element id=Item 2]Item 2[/interactive-element]</li>
                <li>[interactive-element id=Item 3]Item 3[/interactive-element]</li>
            </ul>
        </html>
        """
    }

    private enum Views {
        static let subviews: [UIView] = [
            InputOutputModuleView(text: "Here is some LaTeX: [math]x^n[/math]"),
            InputOutputModuleView(text: "<html><p>&nbsp; 1. Testing non zero width spaces<br> ​  2. Some additional content here.</p></html>"),
            InputOutputModuleView(text: "# Here is some Markdown:\n`Wow this is great!`"),
            InputOutputModuleView(text: "Here is a YouTube video: youtube[DLzxrzFCyOs]"),
            InputOutputModuleView(text: "<html><p>Here is some HTML</p></html>"),
            InputOutputModuleView(text: "<html>Some bullets: <ul><li>Item 1</li><li>Item 2</li><li>Item 3</li></ul></html>"),
            InputOutputModuleView(text: Text.bulletListHTMLWithInteractiveElements),
            InputOutputModuleView(text: "Here is some code: [code]print('Hello World!')[/code]"),
            InputOutputModuleView(text: "Here is a Vimeo video: vimeo[100708006]"),
            InputOutputModuleView(text: "<a href='https://www.google.com'>jump to page</a>"),
            InputOutputModuleView(text: Text.tableHTML),
            InputOutputModuleView(text: "<blockquote>Here is a blockquote</blockquote>"),
            InputOutputModuleView(text: "Look [interactive-element id=123]This is an interactive element[/interactive-element] Wow"),
            InputOutputModuleView(text: "Look [highlighted-element id=456]This is an highlighted element[/highlighted-element] Wow"),
            InputOutputModuleView(text: "Here is more LaTeX [math]A^{}=P^{}\\left(1+\\frac{r}{n}\\right)^{nt}[/math]"),
            InputOutputModuleView(text: "Multiple Latex and Markdwon: *Yes* [math]_2[/math]TEST[math]_3[/math]")
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
