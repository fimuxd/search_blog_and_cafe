//
//  DKCafeDocument.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

struct DKCafeDocument: Codable {
    let title: String
    let contents: String
    let url: URL?
    let cafeName: String
    let thumbnailURL: URL?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, contents, url, datetime
        case thumbnailURL = "thumbnail"
        case cafeName = "cafename"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try values.decode(String.self, forKey: .title)
        self.contents = try values.decode(String.self, forKey: .contents)
        self.url = try? values.decode(URL.self, forKey: .url)
        self.cafeName = try values.decode(String.self, forKey: .cafeName)
        self.thumbnail = try values.decode(String.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}
