//
//  SearchListView.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchListViewBindable {
    var headerViewModel: FilterViewModel { get }
    var searhListCellData: Driver<[SearchListCellData]> { get }
    var itemSelected: PublishRelay<Int> { get }
    var willDisplayCell: PublishRelay<Int> { get }
}

class SearchListView: UITableView {
    var disposeBag = DisposeBag()
    
    let headerView = FilterView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 50)))
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchListViewBindable) {
        self.disposeBag = DisposeBag()
        
        headerView.bind(viewModel.headerViewModel)
        
        viewModel.searhListCellData
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "SearchListCell", for: index) as! SearchListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        self.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        self.rx.willDisplayCell
            .map { $0.indexPath.row }
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(SearchListCell.self, forCellReuseIdentifier: "SearchListCell")
        self.separatorStyle = .singleLine
        self.tableHeaderView = headerView
    }
}
