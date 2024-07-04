//
//  PostViewModal.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import RxSwift
import RxCocoa
import CoreData

class PostsViewModel {
    
    var posts: Driver<[Post]>?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let apiService: APIService
    
    let reloadTableView = PublishSubject<Bool>();
    
    init(apiService: APIService) {
        self.apiService = apiService
        
        fetchPostsFromAPIAndSaveToCoreData()
    }
    
    private func fetchPostsFromAPIAndSaveToCoreData() {
        let postsFromAPI = self.apiService.fetchPosts()
            .flatMap { posts -> Observable<[Post]> in
                return Observable.create { observer -> Disposable in
                    let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

                    // Clear existing data
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    do {
                        try self.context.execute(deleteRequest)
                        try self.context.save()
                    } catch {
                        observer.onError(error)
                    }
                    
                    // Save new data
                    for postModel in posts {
                        let entity = Post(context: self.context)
                        entity.id = Int32(postModel.id)
                        entity.title = postModel.title
                        entity.body = postModel.body
                        entity.isFavorite = false
                    }
                    
                    do {
                        try self.context.save()
                        let savedPosts = try self.context.fetch(fetchRequest)
                        observer.onNext(savedPosts)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                    return Disposables.create()
                }
            }
        
        let postsObservable = postsFromAPI
            .catch { _ in
                return self.fetchPostsFromCoreData()
            }
            .catchAndReturn([]) // If both API and Core Data fetch fail, return an empty array
            .share(replay: 1)
        
        self.posts = postsObservable.asDriver(onErrorJustReturn: [])
    }
    
    private func fetchPostsFromCoreData() -> Observable<[Post]> {
        return Observable.create { observer -> Disposable in
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            do {
                let posts = try self.context.fetch(fetchRequest)
                observer.onNext(posts)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func toggleFavorite(post: Post) {
        post.isFavorite = !post.isFavorite
        do {
            try context.save()
            reloadTableView.onNext(true)
        } catch {
            print("Failed to update favorite status: \(error)")
        }
    }
}
