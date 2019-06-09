//
//  AuthCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

/// Coordinates login/sign up process
class AuthCoordinator: Coordinator {
    let authService: AuthService
    
    let loginViewController: LoginViewController
    
    lazy var signupViewController: SignupViewController = {
        let signupViewController = SignupViewController()
        signupViewController.delegate = self
        return signupViewController
    }()
    
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController, authService: AuthService) {
        self.presenter = presenter
        self.authService = authService
        
        loginViewController = LoginViewController()
        loginViewController.delegate = self
    }
    
    func start() {
        presenter.viewControllers = [loginViewController]
    }
}

extension AuthCoordinator: LoginViewControllerDelegate {
    func login(with email: String, password: String) {
        authService.login(with: email, password: password) { [unowned self] error in
            if let error = error {
                self.presenter.showError(error.localizedDescription)
            }
        }
    }
    
    func showSignup() {
        presenter.pushViewController(signupViewController, animated: true)
    }
}

extension AuthCoordinator: SignupViewControllerDelegate {
    func signup(with email: String, password: String) {
        authService.signup(with: email, password: password) { [unowned self] error in
            if let error = error {
                self.presenter.showError(error.localizedDescription)
            }
        }
    }
    
    func showLogin() {
        presenter.popViewController(animated: true)
    }
}
