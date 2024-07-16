//
//  RealmPostRepository.swift
//  InstPost
//
//  Created by Amit singh on 15/07/24.
//

import Foundation
import RxSwift
import RealmSwift

class PostRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var isFavorite = false


    override static func primaryKey() -> String? {
        return "id"
    }
}

enum RealmError: Error {
    case selfNotFound
    case unableToSave
    case unableToDelete
}

class RealmPostRepository: PostRepository {
    
    private let realm = try! Realm()
    
    func fetchPosts(with predicate: String? = nil) -> Single<[PostEntity]> {
        return Single.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.failure(RealmError.selfNotFound))
                return disposable
            }
            
            var posts = self.realm.objects(PostRealm.self)
            
            if let predicate = predicate {
                posts = posts.filter(predicate)
            }
            
            let postEntities = posts.map { PostEntity(id: $0.id, title: $0.title, body: $0.body, isFavorite: $0.isFavorite) }
            observer(.success(Array(postEntities)))
            
            return disposable
        }
    }
    
    func fetchPost(withId id: Int) -> Single<PostEntity?> {
        return Single.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.failure(RealmError.selfNotFound))
                return disposable
            }
            
            if let post = self.realm.object(ofType: PostRealm.self, forPrimaryKey: id) {
                let postEntity = PostEntity(id: post.id, title: post.title, body: post.body, isFavorite: post.isFavorite)
                observer(.success(postEntity))
            } else {
                observer(.success(nil))
            }
            
            return disposable
        }
    }
    
    func save(post: PostEntity) -> Completable {
        return Completable.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.error(RealmError.selfNotFound))
                return disposable
            }
            
            do {
                try self.realm.write {
                    let postRealm = PostRealm()
                    postRealm.id = post.id
                    postRealm.title = post.title
                    postRealm.body = post.body
                    postRealm.isFavorite = post.isFavorite
                    self.realm.add(postRealm, update: .modified)
                }
                observer(.completed)
            } catch {
                observer(.error(RealmError.unableToSave))
            }
            
            return disposable
        }
    }
    
    func save(posts: [PostEntity]) -> Completable {
        return Completable.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.error(RealmError.selfNotFound))
                return disposable
            }
            
            do {
                try self.realm.write {
                    for post in posts {
                        let postRealm = PostRealm()
                        postRealm.id = post.id
                        postRealm.title = post.title
                        postRealm.body = post.body
                        postRealm.isFavorite = post.isFavorite
                        self.realm.add(postRealm, update: .modified)
                    }
                }
                observer(.completed)
            } catch {
                observer(.error(RealmError.unableToSave))
            }
            
            return disposable
        }
    }
    
    func deleteAllPosts() -> Completable {
        return Completable.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.error(RealmError.selfNotFound))
                return disposable
            }
            
            do {
                try self.realm.write {
                    let posts = self.realm.objects(PostRealm.self)
                    self.realm.delete(posts)
                }
                observer(.completed)
            } catch {
                observer(.error(RealmError.unableToDelete))
            }
            
            return disposable
        }
    }
}
