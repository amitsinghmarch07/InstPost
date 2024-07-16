//
//  CoreDataContextFactory.swift
//  InstPost
//
//  Created by Amit singh on 05/07/24.
//

import UIKit
import CoreData
enum DatabaseType: String {
    case coreData = "coredata"
    case Realm = "realm"
}
class DatabaseFactory {
    static func getDatabase() -> PostRepository {
        guard let databaseType = DatabaseType(rawValue:Configuration.shared.databaseType.lowercased()) else {
            return RealmDatabaseFactory.getDatabase()
        }
        
        switch databaseType {
        case .coreData:
            print(databaseType)

            return CoreDataDatabaseFactory.getDatabase()
        case .Realm:
            print(databaseType)

            return RealmDatabaseFactory.getDatabase()
        }
    }
}
class CoreDataDatabaseFactory {
    static func getDatabase() -> PostRepository {
        let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return CoreDataPostRepository(context: context)
    }
}

class RealmDatabaseFactory {
    static func getDatabase() -> PostRepository {
        return RealmPostRepository()
    }
}
