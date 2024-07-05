//
//  LoginViewModelTests.swift
//  InstPostTests
//
//  Created by Amit singh on 05/07/24.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import InstPost

final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testEmailValidation() {
        // Test invalid email
        scheduler.createColdObservable([
            .next(0, "test@example.com")
        ])
        .bind(to: viewModel.email)
        .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(10, "short"),
            .next(20, "validPassword123")
        ])
        .bind(to: viewModel.password)
        .disposed(by: disposeBag)
        
        let result = scheduler.start(created: 0, subscribed: 0, disposed: 30) { self.viewModel.isValid }
        
        let expectedEvents = [
            Recorded.next(0, false),  // Initial state with valid email but empty password
            Recorded.next(10, false), // Valid email but invalid short password at 10
            Recorded.next(20, false),  // Both email and password are valid at 20
        ]
        
        XCTAssertEqual(result.events, expectedEvents)
    }
    
    func testPasswordValidation() {
        // Test invalid password
        scheduler.createColdObservable([
            .next(10, "test@example.com")
        ])
        .bind(to: viewModel.email)
        .disposed(by: disposeBag)
        
        scheduler.createColdObservable([
            .next(20, "validPass123")
        ])
        .bind(to: viewModel.password)
        .disposed(by: disposeBag)
        
        let result = scheduler.start(created: 0, subscribed: 0, disposed: 30) { self.viewModel.isValid }
        
        let expectedEvents = [
            Recorded.next(0, false),  // Initial state with empty email and password
            Recorded.next(10, false), // Valid email but empty password at 10
            Recorded.next(20, true),  // Both email and password are valid at 20
        ]
        
        XCTAssertEqual(result.events, expectedEvents)
    }
    
    func testValidCredentials() {
        // Test valid email and password
        let emailObservable = scheduler.createColdObservable([
                    .next(10, "test@example.com")
                ])
                emailObservable.bind(to: viewModel.email).disposed(by: disposeBag)
                
                let passwordObservable = scheduler.createColdObservable([
                    .next(20, "validPass123")
                ])
                passwordObservable.bind(to: viewModel.password).disposed(by: disposeBag)
                
                let result = scheduler.start(created: 0, subscribed: 0, disposed: 30) { self.viewModel.isValid }
                
                let expectedEvents = [
                    Recorded.next(0, false),  // Initial state with empty email and password
                    Recorded.next(10, false), // Valid email but empty password at 10
                    Recorded.next(20, true),  // Both email and password are valid at 20
                ]
                
                XCTAssertEqual(result.events, expectedEvents)    }
}

