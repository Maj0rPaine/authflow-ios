//
//  ProfileViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    
    private var user: User?
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = user?.email
    }
}
