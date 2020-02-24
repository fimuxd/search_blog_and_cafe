//
//  HistoryListView.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/24.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HistoryListViewBindable {
    var historyListCellData: Driver<[String]> { get }
    var itemSelected: PublishRelay<Int> { get }
}

class HistoryListView: UITableView {
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: HistoryListViewBindable) {
        self.disposeBag = DisposeBag()
     
        viewModel.historyListCellData
            .drive(self.rx.items) { tv, row, text in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "HistoryListCell", for: index)
                cell.textLabel?.text = text
                return cell
            }
            .disposed(by: disposeBag)
        
        self.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryListCell")
        self.separatorStyle = .singleLine
    }
}
