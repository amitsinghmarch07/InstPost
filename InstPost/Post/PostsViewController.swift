//
//  PostViewController.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class PostsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PostsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomCell")

//         Bind posts to tableView
        viewModel.posts
            .bind(to: tableView.rx.items(cellIdentifier: "PostsTableViewCell", cellType: PostsTableViewCell.self)) { index, model, cell in
                cell.postTitle?.text = model.title
                // Set other cell properties
            }
            .disposed(by: disposeBag)
        
        // Fetch posts
        viewModel.fetchPosts()
        
        // Handle post selection
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.markAsFavorite(post: post)
            })
            .disposed(by: disposeBag)
    }
}
