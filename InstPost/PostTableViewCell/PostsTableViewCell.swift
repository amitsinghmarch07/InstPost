//
//  PostsTableViewCell.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
