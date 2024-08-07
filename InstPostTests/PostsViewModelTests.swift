//
//  PostsViewModelTests.swift
//  InstPostTests
//
//  Created by Amit singh on 05/07/24.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import CoreData

@testable import InstPost

class PostsViewModelTests: XCTestCase {
    
    var viewModel: PostsViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockContext: NSManagedObjectContext!
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "InstPost")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    override func setUp() {
        super.setUp()
        
        mockContext = persistentContainer.viewContext
        
        // Mock APIService
        let apiService = MockAPIService()
        
        // ViewModel setup
        viewModel = PostsViewModel(context: mockContext, apiService: apiService)
        
        // RxTest setup
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        disposeBag = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testFetchPostsFromAPIAndSaveToCoreData() {
        // Create an observer to capture the emitted events
        let observer = scheduler.createObserver([Post].self)
        
        // Subscribe the observer to the posts observable
        viewModel.posts.drive(observer).disposed(by: disposeBag)
        
        // Start the scheduler to begin the emission of events
        scheduler.start()
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element?.count, 2)
        // Assert that the actual events match the expected events
        XCTAssertEqual(((observer.events[0].value.element as? NSArray)?.object(at: 0) as? InstPost.Post)?.id, 1);
        XCTAssertEqual(((observer.events[0].value.element as? NSArray)?.object(at: 0) as? InstPost.Post)?.title, "Post 1");
        XCTAssertEqual(((observer.events[0].value.element as? NSArray)?.object(at: 1) as? InstPost.Post)?.id, 2);
        XCTAssertEqual(((observer.events[0].value.element as? NSArray)?.object(at: 1) as? InstPost.Post)?.title, "Post 2");
    }
}
