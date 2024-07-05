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
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Unknown"
        body = try container.decode(String.self, forKey: .body)
        isFavorite = false

    }
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = false
    }
}
