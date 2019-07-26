---
id: overview
title: Overview
---

[![Cocoapods](https://img.shields.io/cocoapods/v/RichTextView.svg)](https://cocoapods.org/pods/RichTextView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Builds](https://img.shields.io/circleci/project/github/tophat/RichTextView.svg)](https://circleci.com/gh/tophat/RichTextView)
[![All Contributors](https://img.shields.io/badge/all_contributors-8-orange.svg?style=flat)](#credits)
[![Slack workspace](https://slackinvite.dev.tophat.com/badge.svg)](https://opensource.tophat.com/slack)
[![License - Apache-2](https://img.shields.io/badge/license-Apache%202-blue.svg?maxAge=2592000)](https://www.apache.org/licenses/LICENSE-2.0/)
[![Maturity badge - level 3](https://img.shields.io/badge/Maturity-Level%203%20--%20Stable-green.svg)](https://github.com/tophat/getting-started/blob/master/scorecard.md)

## About

iOS Text View (`UIView`) that Properly Displays LaTeX, HTML, Markdown, and YouTube/Vimeo Links


## Installation

### Using Cocoapods

Simply add the following to your Podfile:

```
pod 'RichTextView'
```

And run `pod install` in your repo.

### Using Carthage

Simply add the following to your Cartfile:

```
github "tophat/RichTextView"
```

And run `carthage update --platform iOS` in your repo.

## Usage

You can instantiate a `RichTextView` by importing the project first:

```
import RichTextView
```
To init a `RichTextView`:

```
let richTextView = RichTextView(
    input: "Test",
    latexParser: LatexParser(),
    font: UIFont.systemFont(ofSize: UIFont.systemFontSize),
    textColor: UIColor.black,
    isSelectable: true,
    isEditable: false,
    latexTextBaselineOffset: 0,
    interactiveTextColor: UIColor.blue,
    textViewDelegate: nil,
    frame: CGRect.zero,
    completion: nil
)
```

You can also update an existing `RichTextView` as follows:

```
richTextView.update(
    input: "Test",
    latexParser: LatexParser(),
    font: UIFont.systemFont(ofSize: UIFont.systemFontSize),
    textColor: UIColor.black,
    latexTextBaselineOffset: 0,
    interactiveTextColor: UIColor.blue,
    completion: nil
)
```

The parameters are defined as follows:

* `input` - The string you want to render
* `latexParser` - You can pass your own class that conforms to `LatexParserProtocol` if you want to handle LaTeX parsing in a custom way. Currently we use the `iosMath` Pod to handle LaTeX parsing by default
* `font` - The font of the text to render
* `texColor` - The color of the text to render
* `isSelectable` - A property that determines whether or not `RichTextView` is selectable
* `isEditable` - A property that determines whether or not `RichTextView` is editable
* `latexTextBaselineOffset` - The baseline offset of the attributed text attachment that represents any LaTeX text that needs to be rendered
* `interactiveTextColor` - The text color of any interactive elements/custom links (see **Interactive element** in `Formatting the input`)
* `textViewDelegate` - A `RichTextViewDelegate` - conforms to `UITextViewDelegate` and also has handling when interactive elements/custom links are tapped
* `frame` - A `CGRect` that represents the frame of the `RichTextView`
* `completion` - A completion block to handle any errors that might be returned. The input will still render even if there are errors, however it might look differently than expected.


### Formatting the input

In order for the `RichTextView` to handle the various use cases it might encounter, the input string needs to be formatted as follows:

* **LaTeX**: Put any text you want to render as LaTeX in between two `[math]` and `[/math]` tags. Example: `[math]x^n[/math]`
* **Code**: Put any text you want to render as code in between two `[code]` and `[/code]` tags. Example: `[code]print('Hello World')[/code]`
* **HTML/Markdown**: No formatting necessary
* **YouTube Videos**: Put the ID of the YouTube video in a YouTube tag as follows: `youtube[dQw4w9WgXcQ]`. The YouTube ID of any video can be found by looking at the URL of the video (Example: `https://www.youtube.com/watch?v=dQw4w9WgXcQ`) and taking the value right after the `v=` URL parameter. In this case the ID of the YouTube video is `dQw4w9WgXcQ`
* **Vimeo Videos**: Put the ID of the Vimeo video in a Vimeo tag as follows: `vimeo[100708006]`. The Vimeo ID of any video can be found by looking at the URL of the video (Example: `https://vimeo.com/100708006`) and taking the value right after the first `/`. In this case the ID of the Vimeo video is `100708006`
* **Interactive element**: If you want to add text that has custom handling when you tap it, put the text in between two `[interactive-element id=<id>]` and `[/interactive-element]` tags. By doing this, when a user taps this text it will call the `didTapCustomLink` function of `RichTextViewDelegate` with the ID of the text that represents the interactive element (`<id>`), so be sure to hook into `RichTextViewDelegate` to capture this.

## Screenshots
<img src="/img/screenshot-1.png" width="300px;"/> <img src="/img/screenshot-2.png" width="300px;"/>

Check out the sample project in the `Example` root folder to see the screenshots above in action!

## Architecture
![Architecture](/img/RichTextView.png)
