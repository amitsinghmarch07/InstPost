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
    
    private let updateToCoreDataSubject = PublishSubject<[Post]>()
    private let postsSubject = BehaviorSubject<[Post]>(value: [])
    var posts: Driver<[Post]> {
        return postsSubject.asDriver(onErrorJustReturn: [])
    }
    private let disposeBag = DisposeBag()
    private let context: NSManagedObjectContext
    var apiService: APIService = APIServiceFactory.getApiService()
    
    let reloadTableView = PublishSubject<Bool>();
    
    init(context: NSManagedObjectContext = CoreDataContextFactory.getContext(),
         apiService: APIService = APIServiceFactory.getApiService()
    ) {
        self.context = context
        self.apiService = apiService
        subscribeCoreDataSubject()
        fetchPostsFromAPIAndSaveToCoreData()
    }
    
    func fetchPostsFromAPIAndSaveToCoreData() {
        self.apiService.fetchPosts()
            .asObservable()
            .subscribe {[unowned self] posts in
                let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                
                // Clear existing data
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                do {
                    try self.context.execute(deleteRequest)
                    try self.context.save()
                } catch {
                    self.updateToCoreDataSubject.onError(error)
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
                    self.updateToCoreDataSubject.onNext(savedPosts)
                    self.updateToCoreDataSubject.onCompleted()
                } catch {
                    self.updateToCoreDataSubject.onError(error)
                }
                
            } onError: {[unowned self] error in
                self.updateToCoreDataSubject.onError(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeCoreDataSubject() {
        updateToCoreDataSubject
            .subscribe(onNext: {[weak self] posts in
                self?.postsSubject.onNext(posts)
            }, onError: {[weak self] error in
                self?.fetchPostsFromCoreData()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPostsFromCoreData() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let posts = try context.fetch(fetchRequest)
            postsSubject.onNext(posts)
        } catch {
            postsSubject.onError(error)
        }
    }
    
    func toggleFavorite(post: Post) {
        context.performAndWait {
            post.isFavorite = !post.isFavorite
            do {
                try context.save()
                fetchPostsFromCoreData()
            } catch {
                print("Failed to update favorite status: \(error)")
            }
        }
    }
}
