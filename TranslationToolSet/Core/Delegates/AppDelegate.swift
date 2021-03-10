//
//  AppDelegate.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == UIMenuSystem.main {
            builder.remove(menu: .format)
            
            let openCommand =
                UIKeyCommand(title: NSLocalizedString("Open XLIFF", comment: ""),
                             image: nil,
                             action: #selector(AppDelegate.openXliffAction),
                             input: "O",
                             modifierFlags: .command,
                             propertyList: nil)
            let openMenu =
                UIMenu(title: "",
                       image: nil,
                       identifier: UIMenu.Identifier("org.mdd.menus.openMenu"),
                       options: .displayInline,
                       children: [openCommand])
            builder.insertChild(openMenu, atStartOfMenu: .file)
        }
    }
    
    @objc private func openXliffAction() {
        MainViewController.instance?.openXliffFile()
    }
}

