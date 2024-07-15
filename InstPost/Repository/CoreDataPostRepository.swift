//
//  CoreDataPostRepository.swift
//  InstPost
//
//  Created by Amit singh on 14/07/24.
//

import RxSwift
import CoreData

enum CoreDataError: Error {
    case selfNotFound
    case unableToSave
    case unableTODelete
}

class CoreDataPostRepository: PostRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func createDefaultFetchRequest() -> NSFetchRequest<Post> {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return fetchRequest
    }
    
    func fetchPosts(with predicate: String? = nil) -> Single<[PostEntity]> {
        return Single.create {[weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.failure(CoreDataError.selfNotFound))
                return disposable
            }


            let fetchRequest = createDefaultFetchRequest()
            
            if let predicate {
                fetchRequest.predicate = NSPredicate(format:predicate)
            }
            
            do {
                let post = try self.context.fetch(fetchRequest)
                observer(.success(getPostEntity(from: post)))
            }catch {
                observer(.failure(CoreDataError.selfNotFound))
            }
            return disposable
        }
    }
    
    func fetchPost(withId id: Int)-> Single<PostEntity?> {
        return Single.create {[weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.failure(CoreDataError.selfNotFound))
                return disposable
            }
            
            let fetchRequest = createDefaultFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            do {
                let post = try self.context.fetch(fetchRequest)
                observer(.success(getPostEntity(from: post).first))
            }catch {
                observer(.failure(CoreDataError.selfNotFound))
            }
            return disposable
        }
    }
    
    func save(post: PostEntity)-> Completable {
        return Completable.create {[weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.error(CoreDataError.selfNotFound))
                return disposable
            }
            
            do {
                try saveToDatabse(posts: [post])
                observer(.completed)
            }catch {
                observer(.error(CoreDataError.unableToSave))
            }
            
            return disposable
        }
    }
    
    func getPostEntity(from posts: [Post]) -> [PostEntity] {
        posts
            .map {
                PostEntity(id: Int($0.id),
                           title: $0.title ?? "",
                           body: $0.body ?? "",
                           isFavorite: $0.isFavorite)
            }
    }
    
    func save(posts: [PostEntity]) -> Completable {
        
        return Completable.create {[weak self] observer in
            let disposable = Disposables.create()
            guard let self else {
                observer(.error(CoreDataError.selfNotFound))
                return disposable
            }
            
            do {
                try saveToDatabse(posts: posts)
                observer(.completed)
            }catch {
                observer(.error(CoreDataError.unableToSave))
            }
            
            return disposable
        }
    }
    
    private func saveToDatabse(posts: [PostEntity]) throws {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        // Save new data
        for postModel in posts {
            guard let model = self.context.persistentStoreCoordinator?.managedObjectModel,
                  let post = model.entitiesByName["Post"]else {
                fatalError("Managed object model not found")
            }
            
            let entity = Post(entity: post, insertInto: self.context)
            entity.id = Int32(postModel.id)
            entity.title = postModel.title
            entity.body = postModel.body
            entity.isFavorite = postModel.isFavorite
        }
        
        try self.context.save()
    }

    func deleteAllPost()-> Completable {
        return Completable.create { [weak self] observer in
            
            let disposable = Disposables.create()
            guard let self else {
                observer(.error(CoreDataError.selfNotFound))
                return disposable
            }
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest:
                                                        self.createDefaultFetchRequest() as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try self.context.execute(deleteRequest)
                try self.context.save()
            } catch {
                observer(.error(CoreDataError.unableTODelete))
            }
            
            return disposable
        }
    }
}
