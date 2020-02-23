//
//  SearchListViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct SearchListViewModel: SearchListViewBindable {
    let headerViewModel = FilterViewModel()
    
    let searhListCellData: Driver<[SearchListCellData]>
    let itemSelected = PublishRelay<Int>()
    
    let data = PublishSubject<[SearchListCellData]>()
    
    init() {
        searhListCellData = data
            .asDriver(onErrorJustReturn: [])
    }
}
