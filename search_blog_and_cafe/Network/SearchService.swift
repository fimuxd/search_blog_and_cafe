//
//  SearchService.swift
//  search_blog_and_cafe
//
//  Created by Bo-Young PARK on 2020/02/21.
//  Copyright © 2020 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

enum SearchServiceError: Error {
    case invalidURL
    case invalidJSON
    case networkError
    
    var message: String {
        switch self {
        case .invalidURL, .invalidJSON:
            return "데이터를 불러올 수 없습니다."
        case .networkError:
            return "네트워크 상태를 확인해주세요."
        }
    }
}

protocol SearchService {
    func searchBlog(query: String, page: Int) -> Single<Result<DKBlog, SearchServiceError>>
    func searchCafe(query: String, page: Int) -> Single<Result<DKCafe, SearchServiceError>>
}

class SearchServiceImpl: SearchService {
    private let session: URLSession
    let api: SearchAPI = SearchAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String, page: Int) -> Single<Result<DKBlog, SearchServiceError>> {
        guard let url = api.searchBlog(query: query, page: page).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 4e78ea35cffb481201121cd3d09455a6", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catchError { _ in
                .just(.failure(.networkError))
            }
            .asSingle()
    }
    
    func searchCafe(query: String, page: Int) -> Single<Result<DKCafe, SearchServiceError>> {
        guard let url = api.searchCafe(query: query, page: page).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 4e78ea35cffb481201121cd3d09455a6", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let cafeData = try JSONDecoder().decode(DKCafe.self, from: data)
                    return .success(cafeData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catchError { _ in .just(Result.failure(.networkError)) }
            .asSingle()
    }
}
