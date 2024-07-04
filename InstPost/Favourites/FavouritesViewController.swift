//
//  FavouritesViewController.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavouritesViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = FavouritesViewModal()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PostsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostsTableViewCell")

        if let tabBarController = self.tabBarController {
            tabBarController.rx.didSelect
                .subscribe(onNext: { [weak self] viewController in
                    // Check if the selected view controller is the current view controller
                    if viewController == self {
                        self?.viewModel.loadFavoritePosts()
                    }
                })
                .disposed(by: disposeBag)
        }
        
        viewModel.reloadTableView
            .subscribe(onNext:{[unowned self] _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.favoritePosts
            .drive(tableView.rx.items(cellIdentifier: "PostsTableViewCell", cellType: PostsTableViewCell.self)) { index, model, cell in
                cell.postTitle?.text = model.title?.capitalizingFirstLetter()
                cell.postDescription.text = model.body?.capitalizingFirstLetter()
                cell.favouriteImageView.image = model.isFavorite ?  UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.favouriteImageView.tintColor = .customCoral
                // Set other cell properties
            }
            .disposed(by: disposeBag)
        
        
        // Handle post selection
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)
            })
            .disposed(by: disposeBag)
    }
}
