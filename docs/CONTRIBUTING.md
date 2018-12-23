---
id: contributing
title: Contributing
---
Simply clone the repo, run `pod install` and you should be good to go

If you want to visually devQA your changes you can navigate to the Example project (found in the root `Example` folder), run `pod install` and then build and run the app. This will show you some common usages of the `RichTextView`.

The example project points to the local copy of the `RichTextView` pod, so any changes made locally will be reflected in the sample project.

However, you need to be on the legacy build system to see your changes reflected. There is a [known issue](https://github.com/CocoaPods/CocoaPods/issues/7966) with caching development Pods and XCode 10.

Feel free to add additional input/output examples to the example project, especially if you add any new functionality.

Also, be sure to run the unit/UI tests locally as part of the devQA process.

## Have a question that wasn't answered?

Join our [slack community](https://opensource.tophat.com/slack) and ask!
