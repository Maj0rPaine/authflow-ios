//
//  AuthCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit
import Firebase

/// Handle routes for auth session
protocol AuthCoordinatorDelegate: class {
    /// Successful auth request for user
    func authSuccess(user: User)
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
    func login(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.presenter.showError(error?.localizedDescription ?? "Error")
                return
            }
            
            self.delegate?.authSuccess(user: user)
        }
    }
}

extension AuthCoordinator: SignupViewControllerDelegate {
    func signup(with email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.presenter.showError(error?.localizedDescription ?? "Error")
                return
            }
            
            self.delegate?.authSuccess(user: user)
        }
    }
}
