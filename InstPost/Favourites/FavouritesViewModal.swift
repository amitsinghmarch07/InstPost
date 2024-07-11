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
    
    private let favoritePostsSubject = BehaviorSubject<[Post]>(value: [])
    var favoritePosts: Driver<[Post]> {
        return favoritePostsSubject.asDriver(onErrorJustReturn: [])
    }
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let reloadTableView = PublishSubject<Bool>();
    
    init() {
        loadFavoritePosts()
    }
    
    func loadFavoritePosts() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let posts = try context.fetch(fetchRequest)
            favoritePostsSubject.onNext(posts)
        } catch {
            favoritePostsSubject.onError(error)
        }
    }
    
    func toggleFavorite(post: Post) {
        context.perform {[weak self] in
            guard let self else { return }
            post.isFavorite = !post.isFavorite
            do {
                try self.context.save()
                self.loadFavoritePosts()
            } catch {
                print("Failed to update favorite status: \(error)")
            }
        }
    }
}
