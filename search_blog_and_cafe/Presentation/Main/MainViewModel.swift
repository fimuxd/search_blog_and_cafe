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
    
    private let blogData = PublishSubject<DKBlog?>()
    private let cafeData = PublishSubject<DKCafe?>()
    private let cellData = PublishSubject<[SearchListCellData]>()
    
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
            .withLatestFrom(cellData) { $1[$0] }
            .map { DetailViewModel(data: $0) }
            .map { PushableView.detailView($0) }
            .asDriver(onErrorDriveWith: .empty())

        //MARK: ViewModel -> View
        typeSelected
            .bind(to: listViewModel.headerViewModel.shouldUpdateType)
//            .disposed(by: disposeBag)
        
        let searchCondition = Observable
            .combineLatest(
                searchViewModel.shouldLoadResult,
                listViewModel.headerViewModel.currentType
            ) { (result: $0, type: $1) }
        
        //MARK: BlogData
        let blogResult = searchCondition
            .filter { !($0.type == .cafe) }
            .map { $0.result }
            .flatMapLatest { model.searchBlog(query: $0!) }
            .share()
                
        let currentBlogData = Observable
            .combineLatest(blogData, cellData)
        
        let shouldMoreBlogData = Observable
            .combineLatest(
                listViewModel.willDisplayCell,
                cellData
            )
            .map(model.shouldMoreFetch)
        
        let updatedBlogResult = shouldMoreBlogData
            .filter { $0 }
            .withLatestFrom(currentBlogData) { ($1.0, $1.1, .blog) }
            .map(model.nextPage)
            .withLatestFrom(searchViewModel.shouldLoadResult) { (query: $1 ?? "", page: $0) }
            .flatMapLatest(model.searchBlog)
            .share()

        let blogValue = Observable
            .merge(blogResult, updatedBlogResult)
            .map { data -> DKBlog? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
        
        blogValue
            .bind(to: blogData)
            .disposed(by: disposeBag)
        
        let blogError = Observable
            .merge(blogResult, updatedBlogResult)
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
        
        //MARK: CafeData
        let cafeResult = searchCondition
            .filter { !($0.type == .blog) }
            .map { $0.result }
            .flatMapLatest { model.searchCafe(query: $0!) }
            .share()
        
        let currentCafeData = Observable
            .combineLatest(cafeData, cellData)
        
        let shouldMoreCafeData = Observable
            .combineLatest(
                listViewModel.willDisplayCell,
                cellData
            )
            .map(model.shouldMoreFetch)
        
        let updatedCafeResult = shouldMoreCafeData
            .filter { $0 }
            .withLatestFrom(currentCafeData) { ($1.0, $1.1, .cafe) }
            .map(model.nextPage)
            .withLatestFrom(searchViewModel.shouldLoadResult) { (query: $1 ?? "", page: $0) }
            .flatMapLatest(model.searchCafe)
            .share()
        
        let cafeValue = Observable
            .merge(cafeResult, updatedCafeResult)
            .map { data -> DKCafe? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
        
        cafeValue
            .bind(to: cafeData)
            .disposed(by: disposeBag)
        
        let cafeError = Observable
            .merge(cafeResult, updatedCafeResult)
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
        
        let blogFiltered = typeSelected
            .filter { $0 == .blog }
            .withLatestFrom(blogValue)
            .map(model.blogResultToCellData)
        
        let cafeFiltered = typeSelected
            .filter { $0 == .cafe }
            .withLatestFrom(cafeValue)
            .map(model.cafeResultToCellData)
        
        //MARK: CellData
        let paging = Observable
            .merge(
                blogValue.map(model.blogResultToCellData),
                cafeValue.map(model.cafeResultToCellData)
            )
            .withLatestFrom(searchCondition) { (data: $0, type: $1.type) }
            .scan([SearchListCellData]()){
                switch $1.type {
                case .all:
                    return $0 + $1.data
                case .blog:
                    return ($0 + $1.data).filter { $0.type == .blog }
                case .cafe:
                    return ($0 + $1.data).filter { $0.type == .cafe }
                }
            }
            
        let typeFiltering = Observable
            .merge(blogFiltered, cafeFiltered)
        
        Observable
            .merge(paging, typeFiltering)
            .bind(to: cellData)
            .disposed(by: disposeBag)
        
        // alertActionTapped = 네트워크 업데이트 시 사용
    }
}
