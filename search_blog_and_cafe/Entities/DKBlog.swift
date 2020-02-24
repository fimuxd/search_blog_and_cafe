//
//  DKBlog.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

protocol DKData {
    var meta: DKMeta { get }
    var documents: [DKDocument] { get }
}

struct DKBlog: Codable, DKData {
    let meta: DKMeta
    let documents: [DKDocument]
}
