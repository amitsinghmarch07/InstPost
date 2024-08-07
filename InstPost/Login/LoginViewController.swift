//
//  ViewController.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var submitButton: UIButton!
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.applyCustomStyle()
        passwordTextField.applyCustomStyle()
        titleLabel.styleTitleLabel()
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(onNext: {[unowned self](isEnabled) in
                self.submitButton.isEnabled = isEnabled
                self.submitButton.styleButton()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "PostTabbarController") as? PostTabbarController {
            
            let navigationController = BaseNavigationViewController(rootViewController: tabBarController)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let window = appDelegate.getKeyWindow() {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}



