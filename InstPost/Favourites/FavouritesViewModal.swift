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
    
    var posts: Driver<[Post]>?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let reloadTableView = PublishSubject<Bool>();
    
    init() {
        self.posts = fetchPostsFromCoreData().asDriver(onErrorJustReturn: [])
    }
    
    private func fetchPostsFromCoreData() -> Observable<[Post]> {
        return Observable.create { observer -> Disposable in
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

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
