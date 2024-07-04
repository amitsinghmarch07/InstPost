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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
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
            // Navigate to ViewControllerB
            
            let navigationController = UINavigationController(rootViewController: tabBarController)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        } else {
            // Show error message
            let alert = UIAlertController(title: "Error", message: "Invalid email or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}



