//
//  RichTextViewUITests.swift
//  RichTextViewUITests
//
//  Created by Ahmed Elkady on 2018-11-20.
//  Copyright (c) 2018 Top Hat. All rights reserved.
//

@testable import RichTextView

import Nimble
import Nimble_Snapshots
import Quick
import Dispatch

class RichTextViewUITests: QuickSpec {
    var richTextView: RichTextView?
    var viewController: UIViewController?
    var window: UIWindow?

    private enum Defaults {
        static let size = CGSize(width: 375.0, height: 667.0)
        static let timeOut: DispatchTimeInterval = .milliseconds(5500)
        static let delay = DispatchTimeInterval.seconds(5)
    }

    override func spec() {
        describe("RichTextView UI") {
            beforeEach {
                self.window = UIWindow(frame: CGRect(origin: .zero, size: Defaults.size))
                self.window?.makeKeyAndVisible()
            }
            context("Rendering Various Strings of Rich Text") {
                it("Renders a regular string with no rich text formatting") {
                    let richTextView = RichTextView(input: "Test", frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Renders a string with LaTeX") {
                    let richTextView = RichTextView(input: "[math]x^n[/math]", frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Renders a string with LaTeX and a custom baseline offset") {
                    let richTextView = RichTextView(
                        input: "Here is some LaTeX: [math]x^n[/math]",
                        latexTextBaselineOffset: -50,
                        frame: CGRect(origin: .zero, size: Defaults.size)
                    )
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Renders a string with Markdown") {
                    let richTextView = RichTextView(input: "* Heading", frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Renders a string with HTML") {
                    let richTextView = RichTextView(input: "<html>Test</html>", frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Renders a string with highlights") {
                    let richTextView = RichTextView(
                        input: "[highlighted-element id=123]Test[/highlighted-element]",
                        customAdditionalAttributes: ["123": [
                            NSAttributedString.Key.backgroundColor: UIColor.lightGray,
                            NSAttributedString.Key.underlineStyle: 1]
                        ],
                        frame: CGRect(origin: .zero, size: Defaults.size
                    ))
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Renders a string with bullet attributes") {
                    let listHTMLString = """
                                <html><head><style>li {
                                    font-size: 18px;}</style></head>
                                    <body><ul id="7662c490-2aba-4a46-807a-7f1982671615"><li id="7662c490-2aba-4a46-807a-7f1982671615">Bullet
                                </ul></body></html>
                        """
                    let richTextView = RichTextView(
                        input: listHTMLString,
                        customAdditionalAttributes: ["bullets": [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]],
                        frame: CGRect(origin: .zero, size: Defaults.size)
                    )
                    richTextView.backgroundColor = UIColor.white
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
            }
            context("Update") {
                it("Updates Input Properly") {
                    let richTextView = RichTextView(frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    richTextView.update(input: "* Heading")
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Updates Font Properly") {
                    let richTextView = RichTextView(frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    richTextView.update(input: "* Heading", font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize))
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Updates Text Color Properly") {
                    let richTextView = RichTextView(frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    richTextView.update(input: "* Heading", textColor: UIColor.red)
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }
                it("Updates highlight Color Properly") {
                    let richTextView = RichTextView(frame: CGRect(origin: .zero, size: Defaults.size))
                    richTextView.backgroundColor = UIColor.white
                    richTextView.update(
                        input: "[highlighted-element id=123]Heading[/highlighted-element]",
                        customAdditionalAttributes: ["123": [
                            NSAttributedString.Key.backgroundColor: UIColor.lightGray,
                            NSAttributedString.Key.underlineStyle: 1]
                        ]
                    )
                    self.richTextView = richTextView
                    self.viewController = UIViewController()
                    self.viewController?.view.addSubview(richTextView)
                    self.window?.rootViewController = self.viewController
                    waitUntil(timeout: Defaults.timeOut) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() +  Defaults.delay, execute: {
                            expect(self.window).to(haveValidSnapshot())
                            done()
                        })
                    }
                }

            }
            afterEach {
                UIView.setAnimationsEnabled(false)
                self.window?.isHidden = true
                self.window = nil
            }
        }
    }
}
