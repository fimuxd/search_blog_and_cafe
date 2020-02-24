//
//  SearchViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct SearchViewModel: SearchViewBindable {
    let queryText = PublishRelay<String?>()
    let searchButtonTapped = PublishRelay<Void>()
    let textDidBeginEditing = PublishRelay<Void>()
    
    let updateQueryText: Signal<String>
    let shouldUpdateQueryText = PublishSubject<String>()
    let shouldLoadResult: Observable<String>
    
    init(model: SearchModel = SearchModel()) {
        updateQueryText = shouldUpdateQueryText
            .asSignal(onErrorSignalWith: .empty())
        
        shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .do(onNext: { text in
                model.setDataToUserDefault(text)
            })
    }
}
