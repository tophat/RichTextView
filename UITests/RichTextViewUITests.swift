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

class RichTextViewUITests: QuickSpec {
    var richTextView: RichTextView?
    var viewController: UIViewController?
    var window: UIWindow?

    private enum Defaults {
        static let size = CGSize(width: 375.0, height: 667.0)
        static let timeOut: TimeInterval = 5.5
        static let delay = DispatchTimeInterval.seconds(5)
    }

    override func spec() {
        describe("RichTextView UI") {
            context("Rendering Various Strings of Rich Text") {
                beforeEach {
                    self.window = UIWindow(frame: CGRect(origin: .zero, size: Defaults.size))
                    self.window?.makeKeyAndVisible()
                }
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
                afterEach {
                    UIView.setAnimationsEnabled(false)
                    self.window?.isHidden = true
                    self.window = nil
                }
            }
        }
    }
}

