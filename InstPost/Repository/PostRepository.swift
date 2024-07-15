//
//  Repository.swift
//  InstPost
//
//  Created by Amit singh on 14/07/24.
//

import RxSwift

protocol PostRepository {
    func fetchPosts()-> Single<[PostEntity]>
    func fetchPost(withId id: Int)-> Single<PostEntity?>
    func save(posts: [PostEntity])-> Completable
    func save(post: PostEntity)-> Completable
    func deleteAllPost()-> Completable
}