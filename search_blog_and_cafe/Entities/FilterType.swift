//
//  FilterType.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/24.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

enum FilterType: Int {
    case all
    case blog
    case cafe
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .blog:
            return "Blog"
        case .cafe:
            return "Cafe"
        }
    }
}
