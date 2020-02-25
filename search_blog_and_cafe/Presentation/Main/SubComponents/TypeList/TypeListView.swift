//
//  TypeListView.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TypeListViewBindable {
    var cellData: Driver<[FilterType]> { get }
    var typeSelected: PublishRelay<FilterType> { get }
}

class TypeListView: UIView {
    var disposeBag = DisposeBag()
    let listView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TypeListViewBindable) {
        self.disposeBag = DisposeBag()
        
        viewModel.cellData
            .drive(listView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "TypeListCell", for: index)
                cell.textLabel?.text = data.title
                return cell
            }
            .disposed(by: disposeBag)
        
        listView.rx.itemSelected
            .map {
                FilterType(rawValue: $0.row) ?? .all
            }
            .bind(to: viewModel.typeSelected)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        listView.backgroundColor = .white
        listView.register(UITableViewCell.self, forCellReuseIdentifier: "TypeListCell")
        listView.separatorStyle = .singleLine
        listView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2
    }
    
    private func layout() {
        addSubview(listView)
        
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
