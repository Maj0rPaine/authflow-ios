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

class LoginViewController: BaseViewController, ScrollViewKeyboardObservable {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    weak var delegate: LoginViewControllerDelegate?
    
    var keyboardObservableScrollView: UIScrollView {
        return scrollView
    }
    
    var keyboardObservableView: UIView {
        return signupButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver(to: .default)
    }
    
    deinit {
        removeKeyboardObserver(from: .default)
    }
    
    @IBAction func submit(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        delegate?.login(with: email, password: password)
    }
    
    @IBAction func showSignup(_ sender: Any) {
        delegate?.showSignup()
    }
}
