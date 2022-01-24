//
//  AppDelegate.swift
//  RichTextView-Example
//
//  Created by Ahmed Elkady on 2018-11-08.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Constants

    private enum StoryboardIdentifiers {
        static let main = "Main"
    }

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Delegate Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIStoryboard(name: StoryboardIdentifiers.main, bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
