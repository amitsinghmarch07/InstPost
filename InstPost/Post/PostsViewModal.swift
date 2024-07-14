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
    private let postsSubject = BehaviorSubject<[PostEntity]>(value: [])
    var posts: Driver<[PostEntity]> {
        return postsSubject.asDriver(onErrorJustReturn: [])
    }
    private let disposeBag = DisposeBag()
    private let database: PostRepository
    var apiService: APIService = APIServiceFactory.getApiService()
    let reloadTableView = PublishSubject<Bool>();
    
    init(database: PostRepository = DatabaseFactory.getDatabase(),
         apiService: APIService = APIServiceFactory.getApiService()
    ) {
        self.database = database
        self.apiService = apiService
        fetchPostsFromAPI()
    }
    
    private func savePosts(posts: [PostEntity]) {
        self.database.save(posts: [posts.first!])
            .subscribe(onCompleted: fetchPostsFromDatabase, onError: updateError)
            .disposed(by: disposeBag)
    }
    
    func fetchPostsFromAPI() {
        self.apiService.fetchPosts()
            .asObservable()
            .subscribe(onNext: savePosts, onError: updateError)
            .disposed(by: disposeBag)
    }
    
    func fetchPostsFromDatabase() {
        self.database.fetchPosts()
            .asObservable()
            .subscribe(onNext: {[weak self] postEntities in
                self?.postsSubject.onNext(postEntities)
            }, onError: updateError)
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite(post: PostEntity) {
        post.isFavorite = !post.isFavorite
        self.database.save(post: post)
            .subscribe(onCompleted: fetchPostsFromDatabase, onError: updateError)
            .disposed(by: disposeBag)
    }
    
    private func updateSuccess() {
        
    }
    
    private func updateError(error: Error) {
        
    }
}
