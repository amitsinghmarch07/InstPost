//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Amit singh on 04/07/24.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var body: String?

}
