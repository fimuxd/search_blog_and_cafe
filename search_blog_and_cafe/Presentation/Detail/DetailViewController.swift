//
//  DetailViewController.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

protocol DetailViewBindable {
    var layoutComponents: Signal<SearchListCellData> { get }
    var urlButtonTapped: PublishRelay<Void> { get }
    var push: Driver<Pushable> { get }
}

class DetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let contentView = UIStackView()
    let thumbnailImageView = UIImageView()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let datetimeLabel = UILabel()
    let urlLabel = UILabel()
    let urlButton = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailViewBindable) {
        self.disposeBag = DisposeBag()
        
        urlButton.rx.tap
            .bind(to: viewModel.urlButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.layoutComponents
            .emit(to: self.rx.layoutComponents)
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { view in
                guard let navigationController = self.navigationController else { return }
                try? view.push(from: navigationController)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        contentView.alignment = .fill
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.spacing = 8
        
        thumbnailImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        datetimeLabel.font = .systemFont(ofSize: 12)
        urlLabel.font =  .systemFont(ofSize: 14, weight: .light)
        
        urlButton.setTitle("바로가기", for: .normal)
        urlButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        let urlView = UIView()
        [urlLabel, urlButton].forEach { urlView.addSubview($0) }
        
        [thumbnailImageView, nameLabel, titleLabel, contentLabel, datetimeLabel, urlView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.center.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
        
        urlLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        
        urlButton.snp.makeConstraints {
            $0.centerY.equalTo(urlLabel)
            $0.trailing.equalToSuperview().inset(8)
            $0.leading.equalTo(urlLabel.snp.trailing).offset(8)
        }
    }
}

extension Reactive where Base: DetailViewController {
    var layoutComponents: Binder<SearchListCellData> {
        return Binder(base) { base, data in
            base.title = data.type.title
            base.thumbnailImageView.kf.setImage(with: data.thumbnailURL)
            base.nameLabel.text = data.name
            base.titleLabel.text = data.title
            base.contentLabel.text = data.contents
            
            var datetime: String {
                let calendar = Calendar(identifier: .gregorian)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
                dateFormatter.locale = Locale(identifier: "ko_kr")
                let contentDate = data.datetime ?? Date()
                
                if calendar.isDateInToday(contentDate) {
                    return "오늘"
                } else if calendar.isDateInYesterday(contentDate) {
                    return "어제"
                } else {
                    return dateFormatter.string(from: contentDate)
                }
            }
            
            base.datetimeLabel.text = datetime
            base.urlLabel.text = data.thumbnailURL?.absoluteString
        }
    }
}
