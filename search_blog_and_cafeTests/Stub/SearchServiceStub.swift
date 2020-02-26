//
//  SearchServiceStub.swift
//  search_blog_and_cafeTests
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import Stubber

@testable import search_blog_and_cafe

class SearchServiceStub: SearchService {
    func searchBlog(query: String, page: Int) -> Single<Result<DKBlog, SearchServiceError>> {
        return Stubber.invoke(searchBlog, args: (query, page))
    }
    
    func searchCafe(query: String, page: Int) -> Single<Result<DKCafe, SearchServiceError>> {
        return Stubber.invoke(searchCafe, args: (query, page))
    }
}
