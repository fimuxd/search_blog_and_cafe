//
//  DKMetaDummy.swift
//  search_blog_and_cafeTests
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation
@testable import search_blog_and_cafe

extension DKBlogDummy {
    struct DKMetaDummy {
        let meta0 = DKMeta(totalCount: 3488, pageableCount: 794, isEnd: false)
    }
}
extension DKCafeDummy {
    struct DKMetaDummy {
        let meta0 = DKMeta(totalCount: 4037, pageableCount: 921, isEnd: true)
    }
}
