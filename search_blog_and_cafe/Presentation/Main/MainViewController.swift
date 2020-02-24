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

    var isTypeListHidden: Signal<Bool> { get }
    var typeListCellData: Driver<[FilterType]> { get }
    var presentAlert: Signal<Void> { get }
    var push: Driver<Pushable> { get }
    var showHistoryList: Signal<Bool> { get }

//    var viewWillAppear: PublishRelay<Void> { get }
    var alertActionTapped: PublishRelay<AlertAction> { get }
    var typeSelected: PublishRelay<FilterType> { get }
}

class MainViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let searchView = SearchView()
    let typeListView = UITableView()
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
        
        
        viewModel.typeListCellData
            .drive(typeListView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "TypeListCell", for: index)
                cell.textLabel?.text = data.title
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { view in
                guard let navigationController = self.navigationController else { return }
                try? view.push(from: navigationController)
            })
            .disposed(by: disposeBag)
        
        viewModel.showHistoryList
            .emit(to: self.rx.showHistoryList)
            .disposed(by: disposeBag)
        
        typeListView.rx.itemSelected
            .map {
                FilterType(rawValue: $0.row) ?? .all
            }
            .bind(to: viewModel.typeSelected)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        typeListView.backgroundColor = .white
        typeListView.register(UITableViewCell.self, forCellReuseIdentifier: "TypeListCell")
        typeListView.separatorStyle = .singleLine
    }
    
    private func layout() {
        [searchView, historyListView, searchListView, typeListView].forEach { view.addSubview($0) }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(topLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        historyListView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchListView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        typeListView.snp.makeConstraints {
            $0.top.equalTo(searchListView).offset(50)
            $0.leading.trailing.equalToSuperview()
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
    var showHistoryList: Binder<Bool> {
        return Binder(base) { base, showHistoryList in
            base.searchListView.isHidden = showHistoryList
            base.historyListView.isHidden = !showHistoryList
        }
    }
}
