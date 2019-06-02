//
//  AuthCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

/// Handle routes for auth session
protocol AuthCoordinatorDelegate: class {
    /// Successful auth request
    func authSuccess()
    /// Failed auth request
    func authFailure()
    /// Expire auth session
    func endSession()
}

/// Coordinates login/sign up process
class AuthCoordinator: Coordinator {
    weak var delegate: AuthCoordinatorDelegate?
    
    let loginViewController: LoginViewController
    
    lazy var signupViewController: SignupViewController = {
        let signupViewController = SignupViewController()
        signupViewController.delegate = self
        return signupViewController
    }()
    
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        loginViewController = LoginViewController()
        loginViewController.delegate = self
    }
    
    func start() {
        showLogin()
    }
}

extension AuthCoordinator {
    func showLogin() {
        presenter.isNavigationBarHidden = true
        presenter.viewControllers = [loginViewController]
    }
    
    func showSignup() {
        presenter.viewControllers = [signupViewController]
    }
}

extension AuthCoordinator: LoginViewControllerDelegate {
    func loginSuccess() {
        delegate?.authSuccess()
    }
}

extension AuthCoordinator: SignupViewControllerDelegate {
    func signupSuccess() {
        delegate?.authSuccess()
    }
}
