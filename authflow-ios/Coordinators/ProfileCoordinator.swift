//
//  ProfileCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/2/19.
//

import UIKit

/// Coordinates access to profile
class ProfileCoordinator: Coordinator {
    weak var delegate: AuthCoordinatorDelegate?
    
    let profileViewController: ProfileViewController
    
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        profileViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(showLogout))
    }
    
    func start() {
        presenter.viewControllers = [profileViewController]
        presenter.isNavigationBarHidden = false
    }
    
    @objc func showLogout() {
        delegate?.endSession()
    }
}
