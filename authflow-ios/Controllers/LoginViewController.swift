//
//  LoginViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginSuccess()
    func showSignup()
}

class LoginViewController: BaseViewController {
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        delegate?.loginSuccess()
    }
    
    @IBAction func showSignup(_ sender: Any) {
        delegate?.showSignup()
    }
}
