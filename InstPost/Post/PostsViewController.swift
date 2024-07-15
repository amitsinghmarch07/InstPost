//
//  PostViewController.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class PostsViewController: BaseViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var emptyView: UIView!

    private let viewModel = PostsViewModel()
    private let disposeBag = DisposeBag()
    
    fileprivate func configureTableView() {
        let nib = UINib(nibName: "PostsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostsTableViewCell")
    }
    
    fileprivate func tableViewDelegateMethods() {
        viewModel.posts
            .drive(tableView.rx.items(cellIdentifier: "PostsTableViewCell", cellType: PostsTableViewCell.self)) { index, model, cell in
                cell.postTitle?.text = model.title.capitalizingFirstLetter()
                cell.postDescription.text = model.body.capitalizingFirstLetter()
                cell.favouriteImageView.image = model.isFavorite ?  UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.favouriteImageView.tintColor = .customCoral
                // Set other cell properties
            }
            .disposed(by: disposeBag)
        
        // Handle post selection
        tableView.rx.modelSelected(PostEntity.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func handleTabbarDidSelect() {
        if let tabBarController = self.tabBarController {
            tabBarController.rx.didSelect
                .subscribe(onNext: { [weak self] viewController in
                    // Check if the selected view controller is the current view controller
                    if viewController == self {
                        self?.viewModel.fetchPostsFromDatabase()
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    fileprivate func reloadTableViewObserver() {
        viewModel.reloadTableView
            .subscribe(onNext:{[unowned self] _ in
                self.tableView.reloadData()
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
        
        reloadTableViewObserver()
        configureTableView()
        tableViewDelegateMethods()
        handleTabbarDidSelect()
        subscribeToEmptyViewHiddenObserver()
    }
}
