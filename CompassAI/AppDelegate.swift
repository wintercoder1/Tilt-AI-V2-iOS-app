//
//  AppDelegate.swift
//  CompassAI
//
//  Created by Steve on 11/5/25.
//

//
//  AppDelegate.swift
//  Compass AI V2
//
//  Created by Steve on 8/21/25.
//

import UIKit


// MARK: - App Delegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
