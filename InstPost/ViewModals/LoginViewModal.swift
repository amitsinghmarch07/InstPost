//
//  LoginViewModal.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable()) { email, password in
            return email.isValidEmail && password.count >= 8 && password.count <= 15
        }
    }
}

extension String {
    var isValidEmail: Bool {
        // Regular expression for validating email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
