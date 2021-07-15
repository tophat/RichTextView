//
//  WKWebViewGeneratorSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class WKWebViewGeneratorSpec: QuickSpec {
    override func spec() {
        describe("WKWebViewGenerator") {
            context("Generate Webviews") {
                it("properly generates a YouTube WebView") {
                    let webview = WKWebViewGenerator.getWebView(from: "youtube[1234]")
                    expect(webview?.configuration.allowsInlineMediaPlayback).to(beTrue())
                    expect(webview?.url?.absoluteString).to(equal("https://www.youtube.com/embed/1234?playsinline=1&cc_load_policy=1"))
                }
                it("properly generates a Vimeo WebView") {
                    let webview = WKWebViewGenerator.getWebView(from: "vimeo[1234]")
                    expect(webview?.configuration.allowsInlineMediaPlayback).to(beTrue())
                    expect(webview?.url?.absoluteString).to(equal("https://player.vimeo.com/video/1234?title=0&byline=0&portrait=0"))
                }
                it("returns nil if it is neither a YouTube or Vimeo video") {
                    let webview = WKWebViewGenerator.getWebView(from: "123")
                    expect(webview).to(beNil())
                }
            }
        }
    }
}
