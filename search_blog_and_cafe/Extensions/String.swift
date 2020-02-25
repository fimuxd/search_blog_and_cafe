//
//  String.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/24.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

extension String {
    // Use for Decodable Date Parsing
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> String? {
        guard let rawString = try? values.decode(String.self, forKey: key) else {
            return nil
        }
        
        return rawString
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: nil)
    }
}
