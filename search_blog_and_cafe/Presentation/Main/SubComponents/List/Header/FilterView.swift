//
//  FilterView.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FilterViewBindable {
    typealias FilterType = FilterView.FilterType
    var updatedType: Signal<FilterType> { get }
    
    var typeButtonTapped: PublishRelay<Void> { get }
    var sortButtonTapped: PublishRelay<Void> { get }
}

class FilterView: UITableViewHeaderFooterView {
    enum FilterType: Int {
        case all
        case blog
        case cafe
        
        var title: String {
            switch self {
            case .all:
                return "All"
            case .blog:
                return "Blog"
            case .cafe:
                return "Cafe"
            }
        }
    }
    
    var disposeBag = DisposeBag()
    
    let typeButton = UIButton()
    let typeList = UIStackView()
    let sortButton = UIButton()
    let bottomBorder = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: FilterViewBindable) {
        self.disposeBag = DisposeBag()
        
        viewModel.updatedType
            .map { $0.title }
            .debug("xxx")
            .emit(to: typeButton.rx.title())
            .disposed(by: disposeBag)
        
        typeButton.rx.tap
            .bind(to: viewModel.typeButtonTapped)
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind(to: viewModel.sortButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        typeButton.setTitleColor(.systemBlue, for: .normal)
        sortButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        bottomBorder.backgroundColor = .lightGray
    }
    
    private func layout() {
        [typeButton, typeList, sortButton, bottomBorder].forEach { addSubview($0) }
        
        typeButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(typeButton.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(35)
        }
        
        bottomBorder.snp.makeConstraints {
            $0.top.equalTo(typeButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
