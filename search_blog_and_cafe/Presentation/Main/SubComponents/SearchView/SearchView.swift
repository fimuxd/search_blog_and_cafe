//
//  SearchView.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchViewBindable {
    var queryText: PublishRelay<String?> { get }
    var searchButtonTapped: PublishRelay<Void> { get }
    var textDidBeginEditing: PublishRelay<Void> { get }
    var updateQueryText: Signal<String> { get }
}

class SearchView: UISearchBar {
    var disposeBag = DisposeBag()
    let searchButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchViewBindable) {
        self.disposeBag = DisposeBag()
        
        self.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        self.rx.textDidBeginEditing
            .bind(to: viewModel.textDidBeginEditing)
            .disposed(by: disposeBag)
        
        viewModel.updateQueryText
            .do(onNext: { [weak self] _ in
                self?.endEditing(true)
            })
            .emit(to: self.searchTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

