//
//  URL.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/23.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

extension URL {
    // Use for Decodable Date Parsing
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> URL? {
        guard let urlString = try? values.decode(String.self, forKey: key),
            let url = URL(string: urlString) else {
                return nil
        }
        
        return url
    }
}
