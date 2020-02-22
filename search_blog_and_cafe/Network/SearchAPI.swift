//
//  SearchAPI.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct SearchAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/search/"
    
    func searchBlog(query: String, page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchAPI.scheme
        components.host = SearchAPI.host
        components.path = SearchAPI.path + "blog"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "25")
        ]
        
        return components
    }
    
    func searchCafe(query: String, page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchAPI.scheme
        components.host = SearchAPI.host
        components.path = SearchAPI.path + "cafe"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "25")
        ]
        
        return components
    }
}
