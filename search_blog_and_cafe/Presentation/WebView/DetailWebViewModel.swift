//
//  DetailWebViewModel.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct DetailWebViewModel: DetailWebViewBindable {
    let urlRequest: URLRequest
    let title: String
    
    init(urlRequest: URLRequest, title: String) {
        self.urlRequest = urlRequest
        self.title = title
    }
}
