//
//  Repository.swift
//  InstPost
//
//  Created by Amit singh on 14/07/24.
//

import RxSwift

protocol PostRepository {
    func fetchPosts(with predicate: String?)-> Single<[PostEntity]>
    func fetchPost(withId id: Int)-> Single<PostEntity?>
    func save(posts: [PostEntity])-> Completable
    func save(post: PostEntity)-> Completable
    func deleteAllPosts()-> Completable
}
