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
    let disposeBag = DisposeBag()
    
    let searchViewModel = SearchViewModel()
    let searchListViewModel = SearchListViewModel()
    let historyListViewModel = HistoryListViewModel()
    
    let typeListCellData: Driver<[FilterType]>
    let presentAlert: Signal<Void>
    let isTypeListHidden: Signal<Bool>
    let push: Driver<Pushable>
    let showHistoryList: Signal<Bool>
    
    let typeSelected = PublishRelay<FilterType>()
    let alertActionTapped = PublishRelay<AlertAction>()
    
    private let blogData = PublishSubject<DKBlog?>()
    private let cafeData = PublishSubject<DKCafe?>()
    private let cellData = PublishSubject<[SearchListCellData]>()
    
    init(model: MainModel = MainModel()) {
        //MARK: ViewModel -> View
        typeListCellData = Driver.of([FilterType.all, FilterType.blog, FilterType.cafe])
        
        presentAlert = searchListViewModel.headerViewModel.sortButtonTapped
            .asSignal(onErrorSignalWith: .empty())
        
        isTypeListHidden = Observable
            .merge(
                searchListViewModel.headerViewModel.typeButtonTapped.map { false },
                typeSelected.map { _ in true }
            )
            .startWith(true)
            .asSignal(onErrorJustReturn: true)
        
        push = searchListViewModel.itemSelected
            .withLatestFrom(cellData) { $1[$0] }
            .map { DetailViewModel(data: $0) }
            .map { PushableView.detailView($0) }
            .asDriver(onErrorDriveWith: .empty())

        typeSelected
            .bind(to: searchListViewModel.headerViewModel.shouldUpdateType)
            .disposed(by: disposeBag)
        
        showHistoryList = Observable
            .merge(
                searchViewModel.textDidBeginEditing.map { true },
                searchViewModel.searchButtonTapped.map { false },
                historyListViewModel.itemSelected.map { _ in false }
            )
            .asSignal(onErrorJustReturn: true)
        
        historyListViewModel.selectedHistory
            .bind(to: searchViewModel.shouldUpdateQueryText)
            .disposed(by: disposeBag)
        
        //MARK: BlogData
        let queryText = Observable
            .merge(
                searchViewModel.shouldLoadResult,
                historyListViewModel.selectedHistory
            )
        
        let searchCondition = Observable
            .combineLatest(
                queryText,
                searchListViewModel.headerViewModel.currentType
            ) { (result: $0, type: $1) }
        
        let blogResult = searchCondition
            .filter { !($0.type == .cafe) }
            .map { $0.result }
            .flatMapLatest { model.searchBlog(query: $0) }
            .share()
                
        let currentBlogData = Observable
            .combineLatest(blogData, cellData)
        
        let shouldMoreBlogData = Observable
            .combineLatest(
                searchListViewModel.willDisplayCell,
                cellData
            )
            .map(model.shouldMoreFetch)
        
        let updatedBlogResult = shouldMoreBlogData
            .filter { $0 }
            .withLatestFrom(currentBlogData) { ($1.0, $1.1, .blog) }
            .map(model.nextPage)
            .withLatestFrom(queryText) { (query: $1, page: $0) }
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
            .flatMapLatest { model.searchCafe(query: $0) }
            .share()
        
        let currentCafeData = Observable
            .combineLatest(cafeData, cellData)
        
        let shouldMoreCafeData = Observable
            .combineLatest(
                searchListViewModel.willDisplayCell,
                cellData
            )
            .map(model.shouldMoreFetch)
        
        let updatedCafeResult = shouldMoreCafeData
            .filter { $0 }
            .withLatestFrom(currentCafeData) { ($1.0, $1.1, .cafe) }
            .map(model.nextPage)
            .withLatestFrom(queryText) { (query: $1, page: $0) }
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
            .scan([SearchListCellData](), accumulator: model.combineCellData)
            
        let typeFiltering = Observable
            .merge(blogFiltered, cafeFiltered)
        
        let updatedCellData = Observable
            .merge(paging, typeFiltering)
        
        Observable
            .combineLatest(
                alertActionTapped.startWith(.title),
                updatedCellData
            )
            .map(model.sortCellData)
            .bind(to: cellData)
            .disposed(by: disposeBag)
            
        cellData
            .bind(to: searchListViewModel.data)
            .disposed(by: disposeBag)
    }
}
