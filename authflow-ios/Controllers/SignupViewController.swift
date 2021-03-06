//
//  SignupViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

protocol SignupViewControllerDelegate: class {
    /// Create FirebaseAuth user
    func signup(with email: String, password: String)
    /// Push login controller on stack
    func showLogin()
}

class SignupViewController: BaseViewController, ScrollViewKeyboardObservable {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate: SignupViewControllerDelegate?
    
    var keyboardObservableScrollView: UIScrollView {
        return scrollView
    }
    
    var keyboardObservableView: UIView {
        get {
            return loginButton
        }
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
        delegate?.signup(with: email, password: password)
    }
    
    @IBAction func showLogin(_ sender: Any) {
        delegate?.showLogin()
    }
}
