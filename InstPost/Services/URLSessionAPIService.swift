//
//  URLSessionAPIService.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import RxSwift

protocol APIService {
    func fetchPosts() -> Observable<[Post]>
}
class URLSessionAPIService {
    static private let shared = URLSessionAPIService()

    func fetchPosts() -> Observable<[Post]> {
        let url = URL(string: baseURL)!

        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    do {
                        let posts = try JSONDecoder().decode([Post].self, from: data)
                        observer.onNext(posts)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
