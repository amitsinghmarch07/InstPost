//
//  CoreDataContextFactory.swift
//  InstPost
//
//  Created by Amit singh on 05/07/24.
//

import UIKit
import CoreData

class CoreDataContextFactory {
    static func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
