//
//  DetailModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct DetailModel {
    let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
        initUserDefault()
    }
    
    func initUserDefault() {
        guard userDefaults.array(forKey: "url_tapped_id") == nil else {
            return
        }
        userDefaults.set([Int](), forKey: "url_tapped_id")
    }
    
    func setDataToUserDefault(_ id: Int) {
        guard var tappedIDList = userDefaults.array(forKey: "url_tapped_id") as? [Int],
            !tappedIDList.contains(id) else {
            return
        }
        tappedIDList.append(id)
        userDefaults.set(tappedIDList, forKey: "url_tapped_id")
    }
}
