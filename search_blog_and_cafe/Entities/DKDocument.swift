//
//  DKDocument.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct DKDocument: Codable {
    let title: String?
    let contents: String?
    let url: URL?
    let cafeName: String?
    let blogName: String?
    let thumbnailURL: URL?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, contents, url, datetime
        case thumbnailURL = "thumbnail"
        case cafeName = "cafename"
        case blogName = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = String.parse(values, key: .title)
        self.contents = String.parse(values, key: .contents)
        self.url = URL.parse(values, key: .url)
        self.cafeName = String.parse(values, key: .cafeName)
        self.blogName = String.parse(values, key: .blogName)
        self.thumbnailURL = URL.parse(values, key: .thumbnailURL)
        self.datetime = Date.parse(values, key: .datetime)
    }
}

extension DKDocument {
    init(title: String?, contents: String?, url: URL?, cafeName: String?, blogName: String?, thumbnailURL: URL?, datetime: Date?) {
        self.title = title
        self.contents = contents
        self.url = url
        self.cafeName = cafeName
        self.blogName = blogName
        self.thumbnailURL = thumbnailURL
        self.datetime = datetime
    }
}
