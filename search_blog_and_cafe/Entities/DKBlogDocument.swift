//
//  DKBlogDocument.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct DKBlogDocument: Codable {
    let title: String
    let contents: String
    let url: URL?
    let blogName: String
    let thumbnail: String
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, contents, url, thumbnail, datetime
        case blogName = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try values.decode(String.self, forKey: .title)
        self.contents = try values.decode(String.self, forKey: .contents)
        self.url = try? values.decode(URL.self, forKey: .url)
        self.blogName = try values.decode(String.self, forKey: .blogName)
        self.thumbnail = try values.decode(String.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}
