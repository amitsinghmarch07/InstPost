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
    
    private let disposeBag = DisposeBag()
    private let updateToCoreDataSubject = PublishSubject<[Post]>()
    private let postsSubject = BehaviorSubject<[PostEntity]>(value: [])
    let isEmptyViewHidden = BehaviorRelay<Bool>(value: true)
    let reloadTableView = PublishSubject<Bool>();
    var posts: Driver<[PostEntity]> {
        return postsSubject.asDriver(onErrorJustReturn: [])
    }
    
    private let database: PostRepository
    private var apiService: APIService = APIServiceFactory.getApiService()
    
    init(database: PostRepository = DatabaseFactory.getDatabase(),
         apiService: APIService = APIServiceFactory.getApiService()
    ) {
        self.database = database
        self.apiService = apiService
        fetchPostsFromAPI()
    }
    
    private func savePosts(posts: [PostEntity]) {
        self.database.save(posts: posts)
            .subscribe(onCompleted: fetchPostsFromDatabase, onError: updateError)
            .disposed(by: disposeBag)
    }
    
    func fetchPostsFromAPI() {
        self.apiService.fetchPosts()
            .asObservable()
            .subscribe(onNext: savePosts,
                       onError: {[weak self] _ in
                self?.fetchPostsFromDatabase()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPostsFromDatabase() {
        self.database.fetchPosts()
            .asObservable()
            .subscribe(onNext: {[weak self] postEntities in
                self?.isEmptyViewHidden.accept(postEntities.count != 0)
                self?.postsSubject.onNext(postEntities)
            }, onError: updateError)
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite(post: PostEntity) {
        var newPost = post
        self.database.save(post: newPost.toggleFavorite())
            .subscribe(onCompleted: fetchPostsFromDatabase, onError: updateError)
            .disposed(by: disposeBag)
    }

    private func updateError(error: Error) {
        self.isEmptyViewHidden.accept(false)
    }
}
