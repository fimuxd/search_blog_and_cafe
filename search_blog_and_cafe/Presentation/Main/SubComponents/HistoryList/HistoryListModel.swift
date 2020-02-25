//
//  HistoryListModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/24.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift

struct HistoryListModel {
    let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func loadHistoryList() -> Observable<[String]> {
        return userDefaults.rx.observe([String].self, "search_history").map { $0 ?? [] }
    }
}
