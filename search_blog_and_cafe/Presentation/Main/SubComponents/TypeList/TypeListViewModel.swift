//
//  TypeListViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct TypeListViewModel: TypeListViewBindable {
    let cellData: Driver<[FilterType]>
    let typeSelected = PublishRelay<FilterType>()
    
    init() {
        cellData = Driver.of([FilterType.all, FilterType.blog, FilterType.cafe])
    }
}

