//
//  AppDelegate.swift
//  TodoYandexApp
//
//  Created by Илья Колесников on 12.06.23.
//

import UIKit
import CocoaLumberjack

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

#if DEBUG
        DDLog.add(DDOSLogger.sharedInstance)            // console logger
#else
        let fileLogger: DDFileLogger = DDFileLogger()   // File Logger
        fileLogger.rollingFrequency = 0
        fileLogger.maximumFileSize = 1 * 1024 * 1024
        fileLogger.logFileManager.maximumNumberOfLogFiles = 2
        DDLog.add(fileLogger)
#endif
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        //      this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
