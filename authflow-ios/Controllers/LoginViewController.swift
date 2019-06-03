//
//  LoginViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    /// Login FirebaseAuth user
    func login(with email: String, password: String)
    /// Pop signup controller from stack
    func showSignup()
}

class LoginViewController: BaseViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    weak var delegate: LoginViewControllerDelegate?
    
    @IBAction func submit(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        delegate?.login(with: email, password: password)
    }
    
    @IBAction func showSignup(_ sender: Any) {
        delegate?.showSignup()
    }
}
