//
//  CoreDataContextFactory.swift
//  InstPost
//
//  Created by Amit singh on 05/07/24.
//

import UIKit
import CoreData

class DatabaseFactory {
    static func getDatabase(managedObjectContext: NSManagedObjectContext? = nil) -> PostRepository {
        let context  = managedObjectContext ?? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return CoreDataPostRepository(context: context)
    }
}
