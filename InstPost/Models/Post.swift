//
//  Post.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import Foundation

struct PostEntity: Codable {
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool = false
}
