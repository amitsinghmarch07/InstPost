//
//  PostViewModal.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import RxSwift
import RxCocoa

class PostsViewModel {
    
    let posts: Driver<[PostEntity]>

    init(apiService: APIService) {
        posts = apiService.fetchPosts()
            .asDriver(onErrorJustReturn: [])
    }
    
    func markAsFavorite(post: Post) {
        // Update the favorite status in Core Data and `favorites`
    }
}
