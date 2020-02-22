//
//  AppDelegate.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = SearchListViewController()
        let rootViewModel = SearchListViewModel()
        rootViewController.bind(rootViewModel)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
