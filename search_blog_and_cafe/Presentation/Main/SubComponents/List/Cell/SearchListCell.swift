//
//  SearchListCell.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import UIKit
import Kingfisher

class SearchListCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let typeLabel = UILabel()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let datetimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: SearchListCellData) {
        thumbnailImageView.kf.setImage(with: data.thumbnailURL)
        typeLabel.text = data.type.title
        nameLabel.text = data.name
        titleLabel.text = data.title
        
        var datetime: String {
            let calendar = Calendar(identifier: .gregorian)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let contentDate = data.datetime ?? Date()
            
            if calendar.isDateInToday(contentDate) {
                return "오늘"
            } else if calendar.isDateInYesterday(contentDate) {
                return "어제"
            } else {
                return dateFormatter.string(from: contentDate)
            }
        }
        
        datetimeLabel.text = datetime
    }
    
    private func attribute() {
        thumbnailImageView.contentMode = .scaleAspectFit
        
        typeLabel.font = .systemFont(ofSize: 12, weight: .light)
        typeLabel.sizeToFit()
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        datetimeLabel.font = .systemFont(ofSize: 12, weight: .light)
    }
    
    private func layout() {
        [thumbnailImageView, typeLabel, nameLabel, titleLabel, datetimeLabel].forEach {
            contentView.addSubview($0)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(typeLabel)
            $0.leading.equalTo(typeLabel.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.trailing.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(typeLabel)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        datetimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(typeLabel)
            $0.trailing.equalTo(titleLabel)
            $0.bottom.equalTo(thumbnailImageView)
        }
    }
}
