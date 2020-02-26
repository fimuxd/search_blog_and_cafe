//
//  DKCafeDummy.swift
//  search_blog_and_cafeTests
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation
@testable import search_blog_and_cafe

struct DKCafeDummy {
    let cafe0 = DKCafe(meta: DKMetaDummy().meta0, documents: [DKDocumentDummy().cafeDoc0, DKDocumentDummy().cafeDoc1, DKDocumentDummy().cafeDoc2])
}
