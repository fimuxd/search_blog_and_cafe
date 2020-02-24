//
//  HistoryListViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/24.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct HistoryListViewModel: HistoryListViewBindable {
    let historyListCellData: Driver<[String]>
    let itemSelected = PublishRelay<Int>()
    
    let selectedHistory: Observable<String>
    
    init(model: HistoryListModel = HistoryListModel()) {
        historyListCellData = model.loadHistoryList()
            .asDriver(onErrorJustReturn: [])
            
        selectedHistory = itemSelected
            .withLatestFrom(model.loadHistoryList()) { $1[$0] }
    }
}
