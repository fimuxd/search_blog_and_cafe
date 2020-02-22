//
//  Date.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation

extension Date {
    // Use for Decodable Date Parsing
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
            let date = from(dateString: dateString) else {
            return nil
        }
        
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "[YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }

        return nil
    }
}
