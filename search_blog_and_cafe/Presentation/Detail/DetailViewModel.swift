//
//  DetailViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

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
