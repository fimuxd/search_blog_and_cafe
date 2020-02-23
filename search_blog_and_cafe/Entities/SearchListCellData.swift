//
//  SearchListCellData.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct SearchListCellData {
    let thumbnailURL: URL?
    let type: FilterView.FilterType
    let name: String
    let title: String
    let contents: String
    let datetime: Date?
    let url: URL?
}
