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
    
    func shouldMoreFetch(_ row: Int, cellData: [SearchListCellData]) -> Bool {
        guard cellData.count > 24 else {
            return false
        }
        
        let lastCellCount = cellData.count
        if lastCellCount - 1 == row {
            return true
        }
        
        return false
    }
    
    func nextPage(_ data: DKData?, _ currentData: [SearchListCellData], for type: FilterType) -> Int {
        guard let meta = data?.meta,
            !meta.isEnd else {
            return 1
        }
        
        let totalCount = Double(meta.totalCount)
        let currentCount = Double(currentData.filter { $0.type == type }.count)
        let size: Double = 25
        let totalPage = (totalCount/size).rounded(.up)
        let nextPage = (totalPage - ((totalCount - currentCount)/size).rounded(.up)) + 1
        
        return Int(nextPage)
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
