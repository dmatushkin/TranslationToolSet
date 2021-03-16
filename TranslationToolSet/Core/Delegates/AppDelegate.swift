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
    
    static let openFileCommand = UIKeyCommand(title: NSLocalizedString("Open XLIFF", comment: ""),
                                          image: nil,
                                          action: #selector(AppDelegate.openXliffAction),
                                          input: "O",
                                          modifierFlags: .command,
                                          propertyList: nil)
    
    static let openFolderCommand = UIKeyCommand(title: NSLocalizedString("Open Xcode exported folder", comment: ""),
                                          image: nil,
                                          action: #selector(AppDelegate.openFolderAction),
                                          input: "F",
                                          modifierFlags: .command,
                                          propertyList: nil)
    
    static let saveCommand = UIKeyCommand(title: NSLocalizedString("Save changes", comment: ""),
                                          image: nil,
                                          action: #selector(AppDelegate.saveChangesAction),
                                          input: "S",
                                          modifierFlags: .command,
                                          propertyList: nil)
    
    static let duplicateCommand = UIKeyCommand(title: NSLocalizedString("Add language", comment: ""),
                                          image: nil,
                                          action: #selector(AppDelegate.duplicateLanguageAction),
                                          input: "D",
                                          modifierFlags: .command,
                                          propertyList: nil).disabled()
    
    static let exportKeysCommand = UIKeyCommand(title: NSLocalizedString("Export words to translate", comment: ""),
                                          image: nil,
                                          action: #selector(AppDelegate.exportTranslationKeys),
                                          input: "E",
                                          modifierFlags: .command,
                                          propertyList: nil).disabled()
    
    static let applyTSVCommand = UIKeyCommand(title: NSLocalizedString("Apply translation", comment: ""),
                                          image: nil,
                                          action: #selector(AppDelegate.applyTSVFile),
                                          input: "A",
                                          modifierFlags: .command,
                                          propertyList: nil).disabled()

    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == UIMenuSystem.main {
            builder.remove(menu: .format)
            
            let openMenu =  UIMenu(title: "",
                                   image: nil,
                                   identifier: UIMenu.Identifier("org.mdd.menus.openMenu"),
                                   options: .displayInline,
                                   children: [AppDelegate.openFileCommand, AppDelegate.openFolderCommand, AppDelegate.saveCommand, AppDelegate.duplicateCommand, AppDelegate.exportKeysCommand, AppDelegate.applyTSVCommand])
            builder.insertChild(openMenu, atStartOfMenu: .file)
        }
    }
    
    @objc private func openXliffAction() {
        MainViewController.instance?.openXliffFile()
    }
    
    @objc private func openFolderAction() {
        MainViewController.instance?.openXcodeExportedFolder()
    }
    
    @objc private func saveChangesAction() {
        MainViewController.instance?.saveChanges()
    }
    
    @objc private func duplicateLanguageAction() {
        MainViewController.instance?.duplicateLanguage()
    }
    
    @objc private func exportTranslationKeys() {
        MainViewController.instance?.exportTranslationKeys()
    }
    
    @objc private func applyTSVFile() {
        
    }
}

