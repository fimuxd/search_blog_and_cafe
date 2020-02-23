//
//  DetailViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct DetailViewModel: DetailViewBindable {
    let layoutComponents: Signal<SearchListCellData>
    let push: Driver<Pushable>
    
    let urlButtonTapped = PublishRelay<Void>()
    
    let data = PublishSubject<SearchListCellData>()
    
    init(data: SearchListCellData) {
        layoutComponents = Signal.of(data)
        
        push = urlButtonTapped
            .map { PushableView.safariView(data.url) }
            .asDriver(onErrorDriveWith: .empty())
    }
}
