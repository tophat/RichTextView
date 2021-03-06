
<div align="center">

# RichTextView

<img src="https://raw.githubusercontent.com/tophat/RichTextView/master/website/static/img/rtv-full-res.png" width="300px;"/>


[![Cocoapods](https://img.shields.io/cocoapods/v/RichTextView.svg)](https://cocoapods.org/pods/RichTextView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Builds](https://img.shields.io/circleci/project/github/tophat/RichTextView/master.svg)](https://circleci.com/gh/tophat/RichTextView)
<br />
[![All Contributors](https://img.shields.io/badge/all_contributors-8-orange.svg?style=flat)](#credits)
[![Discord](https://img.shields.io/discord/809577721751142410)](https://discord.gg/YhK3GFcZrk)
[![License - Apache-2](https://img.shields.io/badge/license-Apache%202-blue.svg?maxAge=2592000)](https://www.apache.org/licenses/LICENSE-2.0/)
[![Maturity badge - level 3](https://img.shields.io/badge/Maturity-Level%203%20--%20Stable-green.svg)](https://github.com/tophat/getting-started/blob/master/scorecard.md)
[![Pull Reminders](https://pullreminders.com/badge.svg)](https://pullreminders.com?ref=badge)

iOS Text View (`UIView`) that Properly Displays LaTeX, HTML, Markdown, and YouTube/Vimeo Links

</div>

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
<img src="https://raw.githubusercontent.com/tophat/RichTextView/master/.github/assets/screenshot-1.png" width="400px;"/> <img src="https://raw.githubusercontent.com/tophat/RichTextView/master/.github/assets/screenshot-2.png" width="400px;"/>

Check out the sample project in the `Example` root folder to see the screenshots above in action!

## Architecture
![Architecture](https://raw.githubusercontent.com/tophat/RichTextView/master/.github/assets/RichTextView.png)

## Contributing
Simply clone the repo, run `pod install` and you should be good to go

If you want to visually devQA your changes you can navigate to the Example project (found in the root `Example` folder), run `pod install` and then build and run the app. This will show you some common usages of the `RichTextView`.

The example project points to the local copy of the `RichTextView` pod, so any changes made locally will be reflected in the sample project.

However, you need to be on the legacy build system to see your changes reflected. There is a [known issue](https://github.com/CocoaPods/CocoaPods/issues/7966) with caching development Pods and XCode 10.

Feel free to add additional input/output examples to the example project, especially if you add any new functionality.

Also, be sure to run the unit/UI tests locally as part of the devQA process.

## Credits

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

| [<img src="https://avatars2.githubusercontent.com/u/6837609?s=100"/><br /><sub><b>Ahmed Elkady</b></sub>](https://github.com/aelkady)<br />[💻](https://github.com/tophat/RichTextView/commits?author=aelkady) 🤔 [⚠️](https://github.com/tophat/RichTextView/commits?author=aelkady) | [<img src="https://avatars0.githubusercontent.com/u/3929954?s=100"/><br /><sub><b>Orla Mitchell</b></sub>](https://github.com/OrlaM)<br />[💻](https://github.com/tophat/RichTextView/commits?author=OrlaM) 🤔 [👀](https://github.com/tophat/RichTextView/commits?author=OrlaM) | [<img src="https://avatars.githubusercontent.com/u/3534236?s=100" width="100px;"/><br /><sub><b>Jake Bolam</b></sub>](https://github.com/jakebolam)<br />[🚇](../.circleci/config.yml)[📖](https://github.com/tophat/RichTextView/commits?author=jakebolam) | [<img src="https://avatars1.githubusercontent.com/u/8632167?s=100"/><br /><sub><b>Sanchit Gera</b></sub>](https://github.com/sanchitgera)<br />[📖](https://github.com/tophat/RichTextView/commits?author=sanchitgera)
| :---: | :---: | :---: | :---: |
| [<img src="https://avatars2.githubusercontent.com/u/8105535?s=100" width="100px;"/><br /><sub><b>Monica Moore</b></sub>](https://github.com/monicamm95)<br />[🎨](http://monicamoore.ca/) | [<img src="https://avatars1.githubusercontent.com/u/39271619?s=100" width="100px;"/><br /><sub><b>Brandon Baksh</b></sub>](https://github.com/brandonbaksh)<br />[📖](https://github.com/tophat/RichTextView/commits?author=brandonbaksh) | [<img src="https://avatars1.githubusercontent.com/u/445636?s=100" width="100px;"/><br /><sub><b>Siavash Bidgoly</b></sub>](https://github.com/syavash)<br />[🚇](../.circleci/config.yml) | [<img src="https://avatars1.githubusercontent.com/u/30090188?s=100" width="100px;"/><br /><sub><b>Stephen Truong</b></sub>](https://github.com/struong9)<br />[📖](https://github.com/tophat/RichTextView/commits?author=struong9)

Thanks to [Carol Skelly](https://github.com/iatek) for donating the Github organization and [Kevin Zhow](https://github.com/kevinzhow) for donating the Pod name!
