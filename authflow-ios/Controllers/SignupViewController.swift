//
//  SignupViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

protocol SignupViewControllerDelegate: class {
    func signupSuccess()
    func showLogin()
}

class SignupViewController: BaseViewController {
    weak var delegate: SignupViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        delegate?.signupSuccess()
    }
    
    @IBAction func showLogin(_ sender: Any) {
        delegate?.showLogin()
    }
}
