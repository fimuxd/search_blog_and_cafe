//
//  MainModelTests.swift
//  search_blog_and_cafeTests
//
//  Created by Bo-Young PARK on 2020/02/25.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import Foundation
import XCTest
import Nimble

@testable import search_blog_and_cafe

class MainModelTests: XCTestCase {
    let stubService = SearchServiceStub()
    
    var blogData0: DKBlog!
    var cafeData0: DKCafe!
    var cellData0: [SearchListCellData]!
    var cellData1: [SearchListCellData]!
    var cellData2: [SearchListCellData]!
    
    var model: MainModel!
    
    override func setUp() {
        self.model = MainModel(service: stubService)
        self.blogData0 = DKBlogDummy().blog0
        self.cafeData0 = DKCafeDummy().cafe0
        self.cellData0 = SearchListCellDataListDummy().cellDataList0
        self.cellData1 = SearchListCellDataListDummy().cellDataList1
        self.cellData2 = [ SearchListCellDataListDummy.SearchListCellDataDummy().cellData0, SearchListCellDataListDummy.SearchListCellDataDummy().cellData1]
    }
    
    func testShouldMoreFetch() {
        let shouldMoreFetch0 = model.shouldMoreFetch(1, cellData: cellData0)
        let shouldMoreFetch1 = model.shouldMoreFetch(24, cellData: cellData1)
        let shouldMoreFetch2 = model.shouldMoreFetch(27, cellData: cellData1)
        
        expect(shouldMoreFetch0).to(
            beFalse(),
            description: "1페이지의 최대 사이즈인 25에 해당하는 cell index에 도달했을 때 다음 페이지를 추가 로드할지 판단합니다. 여기서는 전체 데이터가 2개로 25에 미치지 못하므로 다음 페이지를 로드하지 않아야 합니다."
        )
        
        expect(shouldMoreFetch1).to(
            beFalse(),
            description: "1페이지의 최대 사이즈인 25에 해당하는 cell index에 도달했을 때 다음 페이지를 추가 로드할지 판단합니다. 여기서는 전체 데이터가 28개이지만 동일한 index에 도달하지 못했으므로 다음 페이지를 로드하지 않아야 합니다."
        )
        
        expect(shouldMoreFetch2).to(
            beTrue(),
            description: "1페이지의 최대 사이즈인 25에 해당하는 cell index에 도달했을 때 다음 페이지를 추가 로드할지 판단합니다. 여기서는 전체 데이터가 28개고 동일한 index에 도달했으므로 다음 페이지를 로드해야합니다."
        )
    }
    
    func testNextPage() {
        let nextPage0 = model.nextPage(blogData0, cellData1, for: .blog)
        let nextPage1 = model.nextPage(cafeData0, cellData0, for: .cafe)
        
        expect(nextPage0).to(
            equal(2),
            description: "meta.isEnd가 false이므로 현재 페이지 기반으로 다음 페이지 수를 계산합니다."
        )
        
        expect(nextPage1).to(
            equal(1),
            description: "meta.isEnd가 true이므로 다음 페이지를 불러올 수 없습니다."
        )
    }
    
    func testCombineCellData() {
        let combineCellData0 = model.combineCellData(cellData0, (cellData1, .blog))
        let combineCellData1 = model.combineCellData(cellData0, (cellData1, .cafe))
        
        expect(combineCellData0).to(
            equal(cellData0 + cellData1),
            description: "설정한 타입의 cell data를 방출해야하며, input 값인 cellData1도 blog 타입의 cell만 보유하므로 둘을 더한 값을 반환해야 합니다."
        )
        
        expect(combineCellData1).to(
            equal([]),
            description: "설정한 타입의 cell data를 방출해야하며, cellData0, cellData1 모두 blog 타입의 cell만 보유하므로 빈 값을 반환해야 합니다."
        )
    }
    
    func testSortCellData() {
        let sortCellData0 = model.sortCellData(.title, cellData0, ids: [0])
        let sortCellData1 = model.sortCellData(.datetime, cellData1, ids: [0])
        
        let expectResult0 = cellData2.sorted { $0.title ?? "" < $1.title ?? "" }
        let expectResult1 = cellData2.sorted { $0.datetime ?? Date() < $1.datetime ?? Date() }
        
        expect(sortCellData0).to(
            equal(expectResult0),
            description: "입력한 hash값이 없고 title을 type으로 전달하였으므로 title 기준 오름차순으로 정렬되어야 합니다. 이 과정에서 중복되는 값은 제거됩니다."
        )
        
        expect(sortCellData1).to(
            equal(expectResult1),
            description: "입력한 hash값이 없고 datetime을 type으로 전달하였으므로 datetime 기준 오름차순으로 정렬되어야 합니다. 이 과정에서 중복되는 값은 제거됩니다."
        )
    }
    
    func testUpdateCellStatus() {
        let updateCellStatus0 = model.updateCellStatus(cellData1, [0])
        
        expect(updateCellStatus0).to(
            equal(cellData1),
            description: "cellData component 중 입력한 ids의 id와 hash값이 일치하는 component의 경우 didURLLinkTapped 값을 변경해줍니다. 여기서는 hash값이 0인 component는 없으므로 입력한 cellData가 그대로 방출되어야 합니다."
        )
    }
}
