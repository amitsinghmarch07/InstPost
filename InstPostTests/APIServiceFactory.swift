//
//  APIServiceFactory.swift
//  InstPostTests
//
//  Created by Amit singh on 05/07/24.
//

import RxSwift

class APIServiceFactory {
    static func getApiService()-> APIService {
        MockAPIService()
    }
}

final class MockAPIService: APIService {
    func fetchPosts() -> Observable<[PostEntity]> {
        print("came here")
        return Observable.just([
            PostEntity(id: 1, title: "Post 1", body: "Body 1"),
            PostEntity(id: 2, title: "Post 2", body: "Body 2")
        ])
    }
}
