//
//  APIServiceFactory.swift
//  InstPost
//
//  Created by Amit singh on 04/07/24.
//

import Foundation

class APIServiceFactory {
    static func getApiService()-> APIService {
        URLSessionAPIService()
    }
}
