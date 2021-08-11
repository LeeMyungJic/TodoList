//
//  AppDelegate.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    static var todoList = [Todo]()
    static var todoHistory = [Todo]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let data = UserDefaults.standard.value(forKey:"historyList") as? Data {
            let getData = try! PropertyListDecoder().decode([Todo].self, from: data)
            AppDelegate.todoHistory = getData
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        print("connecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("didDiscard")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

