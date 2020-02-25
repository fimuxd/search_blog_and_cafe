//
//  SearchModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/24.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct SearchModel {
    let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
        initUserDefault()
    }
    
    func initUserDefault() {
        guard userDefaults.array(forKey: "search_history") == nil else {
            return
        }
        userDefaults.set([String](), forKey: "search_history")
    }
    
    func setDataToUserDefault(_ text: String?) {
        guard var historyList = userDefaults.array(forKey: "search_history") as? [String],
            let text = text,
            !historyList.contains(text) else {
            return
        }
        
        historyList.append(text)
        userDefaults.set(historyList, forKey: "search_history")
    }
}
