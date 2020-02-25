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
    
    init(
        data: SearchListCellData,
        model: DetailModel = DetailModel()
    ) {
        layoutComponents = Signal.of(data)
        
        push = urlButtonTapped
            .map { data.hashValue }
            .do(onNext: model.setDataToUserDefault)
            .map { _ in
                guard let url = data.url else {
                    return nil
                }
                return DetailWebViewModel(urlRequest: URLRequest(url: url), title: data.title ?? "")
            }
            .filter { $0 != nil }
            .map { PushableView.webView($0!) }
            .asDriver(onErrorDriveWith: .empty())
    }
}
