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
        
    func fetchPosts(with predicate: String? = nil) -> Single<[PostEntity]> {
        return Single.create { observer in
            let disposable = Disposables.create()
            guard let realm = try? Realm()
            else {
                observer(.failure(RealmError.selfNotFound))
                return disposable
            }
            
            var posts = realm.objects(PostRealm.self)
            
            if let predicate = predicate {
                posts = posts.filter(predicate)
            }
            
            let postEntities = posts.map { PostEntity(id: $0.id, title: $0.title, body: $0.body, isFavorite: $0.isFavorite) }
            observer(.success(Array(postEntities)))
            
            return disposable
        }
    }
    
    func fetchPost(withId id: Int) -> Single<PostEntity?> {
        return Single.create { observer in
            let disposable = Disposables.create()
            guard let realm = try? Realm() else {
                observer(.failure(RealmError.selfNotFound))
                return disposable
            }
            
            if let post = realm.object(ofType: PostRealm.self, forPrimaryKey: id) {
                let postEntity = PostEntity(id: post.id, title: post.title, body: post.body, isFavorite: post.isFavorite)
                observer(.success(postEntity))
            } else {
                observer(.success(nil))
            }
            
            return disposable
        }
    }
    
    func save(post: PostEntity) -> Completable {
        return Completable.create { observer in
            let disposable = Disposables.create()
            guard let realm = try? Realm() else {
                observer(.error(RealmError.selfNotFound))
                return disposable
            }
            
            do {
                try realm.write {
                    let postRealm = PostRealm()
                    postRealm.id = post.id
                    postRealm.title = post.title
                    postRealm.body = post.body
                    postRealm.isFavorite = post.isFavorite
                    realm.add(postRealm, update: .modified)
                }
                observer(.completed)
            } catch {
                observer(.error(RealmError.unableToSave))
            }
            
            return disposable
        }
    }
    
    func save(posts: [PostEntity]) -> Completable {
        return Completable.create { observer in
            let disposable = Disposables.create()
            guard let realm = try? Realm() else {
                observer(.error(RealmError.selfNotFound))
                return disposable
            }
            
            do {
                try realm.write {
                    for post in posts {
                        let postRealm = PostRealm()
                        postRealm.id = post.id
                        postRealm.title = post.title
                        postRealm.body = post.body
                        postRealm.isFavorite = post.isFavorite
                        realm.add(postRealm, update: .modified)
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
        return Completable.create { observer in
            let disposable = Disposables.create()
            guard let realm = try? Realm() else {
                observer(.error(RealmError.selfNotFound))
                return disposable
            }
            
            do {
                try realm.write {
                    let posts = realm.objects(PostRealm.self)
                    realm.delete(posts)
                }
                observer(.completed)
            } catch {
                observer(.error(RealmError.unableToDelete))
            }
            
            return disposable
        }
    }
}
