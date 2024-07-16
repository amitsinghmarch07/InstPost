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
    @IBOutlet weak private var emptyView: UIView!

    private let viewModel = FavouritesViewModal()
    private let disposeBag = DisposeBag()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavoritePosts()
    }

    fileprivate func configureTableView() {
        let nib = UINib(nibName: "PostsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostsTableViewCell")
    }

    fileprivate func tableViewReloadObserver() {
        viewModel.reloadTableView
            .subscribe(onNext:{[weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func tableViewDelegateMethods() {
        viewModel.favoritePosts
            .drive(tableView.rx.items(cellIdentifier: "PostsTableViewCell", cellType: PostsTableViewCell.self)) { index, model, cell in
                cell.postTitle?.text = model.title.capitalizingFirstLetter()
                cell.postDescription.text = model.body.capitalizingFirstLetter()
                cell.favouriteImageView.image = model.isFavorite ?  UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.favouriteImageView.tintColor = .customCoral
            }
            .disposed(by: disposeBag)
        
        // Handle post selection
        tableView.rx.modelSelected(PostEntity.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeToEmptyViewHiddenObserver() {
        viewModel
            .isEmptyViewHidden
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isEmptyViewHidden
            .observe(on: MainScheduler.instance)
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        tableViewReloadObserver()
        tableViewDelegateMethods()
        subscribeToEmptyViewHiddenObserver()
    }
}
