//
//  CoreDataContextFactory.swift
//  InstPost
//
//  Created by Amit singh on 05/07/24.
//

import UIKit
import CoreData
enum DatabaseType {
    case coreData(NSManagedObjectContext?)
    case Realm
}
class DatabaseFactory {
    static func getDatabase(type: DatabaseType = .coreData((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)) -> PostRepository {
        switch type {
        case .coreData(let context):
            return CoreDataDatabaseFactory.getDatabase(managedObjectContext: context)
        case .Realm:
            return RealmDatabaseFactory.getDatabase()
        }
    }
}
class CoreDataDatabaseFactory {
    static func getDatabase(managedObjectContext: NSManagedObjectContext? = nil) -> PostRepository {
        let context  = managedObjectContext ?? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return CoreDataPostRepository(context: context)
    }
}

class RealmDatabaseFactory {
    static func getDatabase() -> PostRepository {
        return RealmPostRepository()
    }
}
