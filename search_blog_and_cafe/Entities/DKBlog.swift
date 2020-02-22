//
//  DKBlog.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct DKBlog: Codable {
    let meta: DKMeta
    let documents: [DKBlogDocument]
}
