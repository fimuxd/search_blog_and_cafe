//
//  MainModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift

struct MainModel {
    let service: SearchService
    
    init(service: SearchService = SearchServiceImpl()) {
        self.service = service
    }
    
    func searchBlog(query: String, page: Int = 1) -> Single<Result<DKBlog, SearchServiceError>> {
        return service.searchBlog(query: query, page: page)
    }
    
    func searchCafe(query: String, page: Int = 1) -> Single<Result<DKCafe, SearchServiceError>> {
        return service.searchCafe(query: query, page: page)
    }
    
    func blogResultToCellData(_ blog: DKBlog?) -> [SearchListCellData] {
        guard let blog = blog else {
            return []
        }
        return blog.documents.map { SearchListCellData(thumbnailURL: $0.thumbnailURL, type: .blog, name: $0.blogName, title: $0.title, contents: $0.contents, datetime: $0.datetime, url: $0.url) }
    }
    
    func cafeResultToCellData(_ cafe: DKCafe?) -> [SearchListCellData] {
        guard let cafe = cafe else {
            return []
        }
        return cafe.documents.map { SearchListCellData(thumbnailURL: $0.thumbnailURL, type: .cafe, name: $0.cafeName, title: $0.title, contents: $0.contents, datetime: $0.datetime, url: $0.url) }
    }
}
