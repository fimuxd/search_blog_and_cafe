//
//  MainViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel: MainViewBindable {
    var disposeBag = DisposeBag()
    
    let searchViewModel = SearchViewModel()
    let listViewModel = SearchListViewModel()
    
    let typeListCellData: Driver<[FilterType]>
    let presentAlert: Signal<Void>
    let isTypeListHidden: Signal<Bool>
    let push: Driver<Pushable>
    
//    let viewWillAppear = PublishRelay<Void>()
    let typeSelected = PublishRelay<FilterType>()
    let alertActionTapped = PublishRelay<AlertAction>()
    
    let resultData = PublishSubject<[SearchListCellData]>()
    
    init(model: MainModel = MainModel()) {
        typeListCellData = Driver.of([FilterType.all, FilterType.blog, FilterType.cafe])
        
        presentAlert = listViewModel.headerViewModel.sortButtonTapped
            .asSignal(onErrorSignalWith: .empty())
        
        isTypeListHidden = Observable
            .merge(
                listViewModel.headerViewModel.typeButtonTapped.map { false },
                typeSelected.map { _ in true }
            )
            .startWith(true)
            .asSignal(onErrorJustReturn: true)
        
        
        push = listViewModel.itemSelected
            .withLatestFrom(resultData) { $1[$0] }
            .map { DetailViewModel(data: $0) }
            .map { PushableView.detailView($0) }
            .asDriver(onErrorDriveWith: .empty())

        //MARK: ViewModel -> View
        typeSelected
            .bind(to: listViewModel.headerViewModel.shouldUpdateType)
//            .disposed(by: disposeBag)
        
        let currentType = listViewModel.headerViewModel.currentType
        
        let blogResult = searchViewModel.shouldLoadResult
            .withLatestFrom(currentType) { (result: $0, type: $1) }
            .filter { !($0.type == .cafe) }
            .map { $0.result }
            .flatMapLatest { model.searchBlog(query: $0!) }
            .share()

        let blogValue = blogResult
            .map { data -> DKBlog? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
            .map(model.blogResultToCellData)
        
        let blogError = blogResult
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
        
        let cafeResult = searchViewModel.shouldLoadResult
            .withLatestFrom(currentType) { (result: $0, type: $1) }
            .filter { !($0.type == .blog) }
            .map { $0.result }
            .flatMapLatest { model.searchCafe(query: $0!) }
            .share()
        
        let cafeValue = cafeResult
            .map { data -> DKCafe? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
            .map(model.cafeResultToCellData)
        
        let cafeError = cafeResult
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
        
        let initialResult = Observable
            .merge(blogValue, cafeValue)
            .scan([]) { $0 + $1 }
        
        let typeFilterResult = typeSelected
            .withLatestFrom(resultData) { type, data in
                data.filter { $0.type == type }
            }
        
        Observable
            .merge(
                initialResult,
                typeFilterResult
            )
            .debug("xxx")
            .bind(to: resultData)
        //            .disposed(by: disposeBag)
        
        resultData
            .map { $0.sorted { $0.title < $1.title } }
            .bind(to: listViewModel.data)
        //            .disposed(by: disposeBag)
        
        
        // alertActionTapped = 네트워크 업데이트 시 사용
    }
}
