//
//  Configuration.swift
//  InstPost
//
//  Created by Amit singh on 16/07/24.
//

import Foundation

class Configuration {
    static let shared = Configuration()
    
    private init() {}
    
    private var config: [String: Any] = {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path),
           let config = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any] {
            return config
        }
        return [:]
    }()
    
    var databaseType: String {
        return config["DatabaseType"] as? String ?? "CoreData"
    }
}
