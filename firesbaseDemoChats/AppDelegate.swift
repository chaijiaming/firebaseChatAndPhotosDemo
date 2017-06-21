//
//  AppDelegate.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 5/15/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var collectionView: UICollectionViewLayout?
    var window: UIWindow?
    var shortcutItem: UIApplicationShortcutItem?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: ViewController(nibName: nil,bundle: nil))
        
        var performShortcutDelegate = true
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            print("Application launched via shortcut")
            self.shortcutItem = shortcutItem
            
            performShortcutDelegate = false
        }
        
        return performShortcutDelegate
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    enum ShortcutIdentifiers: String {
        case postaction
        case contact
        case logout
        case play
        
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last
                else{ return nil}
            self.init(rawValue: last)
        }
        
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        handleShortcut(shortcutItem)
        
        
        
        
    }
    
    func handleShortcut(_ shortcutItem: UIApplicationShortcutItem){
        
        
        if shortcutItem.type == "jiamingchai.demo.firesbaseDemoChats.postaction" {
            // taking photos and short videos
            
            let cameraView = PhotoPickerViewController()
            let nav = self.window?.rootViewController as! UINavigationController
            
            nav.pushViewController(cameraView, animated: true)
            
        }
        
        if shortcutItem.type == "jiamingchai.demo.firesbaseDemoChats.contact"{
            // looking for users
            let userView = NewMessageController()
            userView.navigationController?.isToolbarHidden = false
            userView.navigationItem.title = "用户列表"
            userView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: #selector(NewMessageController.handleCancel))
            
            let nav = self.window?.rootViewController as! UINavigationController
            
            nav.pushViewController(userView, animated: true)
            

            
        }
        
        if shortcutItem.type == "jiamingchai.demo.firesbaseDemoChats.logout"{
            // logout the current user
            do{
                try FIRAuth.auth()?.signOut()
            } catch let logoutEror{
                print(logoutEror)
            }
            let nav = self.window?.rootViewController as! UINavigationController
            nav.pushViewController(LoginController(), animated: true)
        }
        
        if shortcutItem.type == "jiamingchai.demo.firesbaseDemoChats.play"{
            // present a new page containing some popular photos
            
            let userView = ViewController(nibName: nil,bundle: nil)
            let nav = self.window?.rootViewController as! UINavigationController
            
            nav.pushViewController(userView, animated: true)
            
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print("Application did become active")
        
        guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
        handleShortcut(shortcut)
        
        self.shortcutItem = nil
    }
    
    


}

