//
//  AppDelegate.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let rootViewModel = BaseViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let rootViewController = BaseViewController()
        rootViewController.bind(rootViewModel)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}
