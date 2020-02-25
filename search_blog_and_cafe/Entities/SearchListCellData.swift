//
//  SearchListCellData.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct SearchListCellData: Hashable {
    let thumbnailURL: URL?
    let type: FilterType
    let name: String?
    let title: String?
    let contents: String?
    let datetime: Date?
    let url: URL?
    var didURLLinkTapped: Bool = false
}
