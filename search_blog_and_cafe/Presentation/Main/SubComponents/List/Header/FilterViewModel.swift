//
//  FilterViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct FilterViewModel: FilterViewBindable {
    let updatedType: Signal<FilterType>
    
    let typeButtonTapped = PublishRelay<Void>()
    let sortButtonTapped = PublishRelay<Void>()
    
    let shouldUpdateType = PublishRelay<FilterType>()
    let currentType: Observable<FilterType>
    
    init() {
        currentType = shouldUpdateType
            .startWith(.all)
        
        updatedType = currentType
            .asSignal(onErrorJustReturn: .all)
    }
}
