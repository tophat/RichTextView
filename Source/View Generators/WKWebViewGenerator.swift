//
//  WKWebViewGenerator.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import WebKit

class WKWebViewGenerator {

    // MARK: - Init

    private init() {}

    // MARK: - Utility Functions

    static func getWebView(from input: String) -> WKWebView? {
        guard let url = WKWebViewGenerator.getWebViewURL(from: input) else {
            return nil
        }
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.load(URLRequest(url: url))
        return webView
    }

    // MARK: - Private Helpers

    private static func getWebViewURL(from input: String) -> URL? {
        if let youTubeID = input.getSubstring(inBetween: RichTextViewConstants.youtubeStartTag, and: RichTextViewConstants.videoEndTag) {
            return URL(string: "https://www.youtube.com/embed/" + youTubeID + "?playsinline=1")
        } else if let vimeoID = input.getSubstring(inBetween: RichTextViewConstants.vimeoStartTag, and: RichTextViewConstants.videoEndTag) {
            return URL(string: "https://player.vimeo.com/video/" + vimeoID + "?title=0&byline=0&portrait=0")
        }
        return nil
    }
}
