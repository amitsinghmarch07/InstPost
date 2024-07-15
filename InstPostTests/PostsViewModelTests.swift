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

class MockREpository: CoreDataPostRepository {
    override func getPostEntity(from posts: [Post]) -> [PostEntity] {
       return (posts as NSArray).compactMap { element in
           
           guard let post = element as? InstPost.Post else { return nil }
           
            return PostEntity(id: Int(post.id),
                       title: post.title ?? "",
                       body: post.body ?? "",
                       isFavorite: post.isFavorite)

        }
    }
}

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
        let coreDataDatabase = MockREpository(context: mockContext)//DatabaseFactory.getDatabase(managedObjectContext: mockContext)
        viewModel = PostsViewModel(database: coreDataDatabase,
                                   apiService: apiService)
        
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
        let observer = scheduler.createObserver([PostEntity].self)
        
        // Subscribe the observer to the posts observable
        viewModel.posts.drive(observer).disposed(by: disposeBag)
        
        // Start the scheduler to begin the emission of events
        scheduler.start()
        
        let postEntities = [
            PostEntity(id: 1, title: "Post 1", body: "Body 1", isFavorite: false),
            PostEntity(id: 2, title: "Post 2", body: "Body 2", isFavorite: false)
        ]
        
        let expectedEvents = [
            Recorded.next(0,postEntities)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
