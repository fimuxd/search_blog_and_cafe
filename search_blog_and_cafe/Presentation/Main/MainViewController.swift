//
//  MainViewController.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import SnapKit

protocol MainViewBindable {
    typealias AlertAction = MainViewController.AlertAction
    
    var searchViewModel: SearchViewModel { get }
    var searchListViewModel: SearchListViewModel { get }
    var historyListViewModel: HistoryListViewModel { get }
    var typeListViewModel: TypeListViewModel { get }

    var isTypeListHidden: Signal<Bool> { get }
    var presentAlert: Signal<Void> { get }
    var push: Driver<Pushable> { get }
    var isHistoryListHidden: Signal<Bool> { get }

    var alertActionTapped: PublishRelay<AlertAction> { get }
}

class MainViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let searchView = SearchView()
    let typeListView = TypeListView()
    let searchListView = SearchListView()
    let historyListView = HistoryListView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewBindable) {
        self.disposeBag = DisposeBag()
   
        searchView.bind(viewModel.searchViewModel)
        searchListView.bind(viewModel.searchListViewModel)
        historyListView.bind(viewModel.historyListViewModel)
        typeListView.bind(viewModel.typeListViewModel)
        
        viewModel.isTypeListHidden
            .emit(to: typeListView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.presentAlert
            .flatMapLatest { _ in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                return self.presentAlertController(alertController, actions: [.title, .datetime, .cancel])
            }
            .emit(to: viewModel.alertActionTapped)
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { view in
                guard let navigationController = self.navigationController else { return }
                try? view.push(from: navigationController)
            })
            .disposed(by: disposeBag)
        
        viewModel.isHistoryListHidden
            .emit(to: self.rx.isHistoryListHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [searchView, searchListView, historyListView, typeListView].forEach { view.addSubview($0) }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(topLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        historyListView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(50)
            $0.bottom.equalTo(view.snp.centerY)
        }
        
        searchListView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        typeListView.snp.makeConstraints {
            $0.top.equalTo(searchListView).offset(50)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-50)
            $0.height.equalTo(140)
        }
    }
}

extension MainViewController {
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "취소"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime:
                return .default
            case .cancel:
                return .cancel
            }
        }
    }
}

extension Reactive where Base: MainViewController {
    var isHistoryListHidden: Binder<Bool> {
        return Binder(base) { base, hideHistoryList in
//            base.searchListView.isHidden = !hideHistoryList
            base.historyListView.isHidden = hideHistoryList
        }
    }
}
