//
//  FavouritesViewModal.swift
//  InstPost
//
//  Created by Amit singh on 04/07/24.
//

import RxSwift
import RxCocoa
import CoreData

class FavouritesViewModal {
    private let disposeBag = DisposeBag()
    private let favoritePostsSubject = BehaviorSubject<[PostEntity]>(value: [])
    var favoritePosts: Driver<[PostEntity]> {
        return favoritePostsSubject.asDriver(onErrorJustReturn: [])
    }
    let isEmptyViewHidden = BehaviorRelay<Bool>(value: true)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let database: PostRepository
    let reloadTableView = PublishSubject<Bool>();
    
    init(database: PostRepository = DatabaseFactory.getDatabase()) {
        self.database = database
    }
    
    func loadFavoritePosts() {
        self.database.fetchPosts(with: "isFavorite == true")
            .asObservable()
            .subscribe(onNext: {[weak self] postEntities in
                self?.isEmptyViewHidden.accept(postEntities.count != 0)
                self?.favoritePostsSubject.onNext(postEntities)
            }, onError: {[weak self] _ in
                self?.isEmptyViewHidden.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite(post: PostEntity) {
        var newPost = post
        
        self.database.save(post: newPost.toggleFavorite())
            .subscribe(onCompleted: {[weak self] in
                    guard var posts = try? self?.favoritePostsSubject.value() else {
                        return
                    }
                    posts.removeAll(where: {$0 == post})
                    self?.favoritePostsSubject.onNext(posts)
            }, onError: updateError)
            .disposed(by: disposeBag)
    }

    private func updateError(error: Error) {
        self.isEmptyViewHidden.accept(false)
    }
}
