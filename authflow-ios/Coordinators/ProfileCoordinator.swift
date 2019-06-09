//
//  ProfileCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/2/19.
//

import UIKit

/// Coordinates access to profile
class ProfileCoordinator: Coordinator {
    let authService: AuthService
    
    let profileViewController: ProfileViewController
        
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController, authService: AuthService) {
        self.presenter = presenter
        self.authService = authService
        
        profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        profileViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(showSettings))
    }
    
    func start() {
        presenter.viewControllers = [profileViewController]
    }
    
    @objc func showSettings() {
        let settingsTableViewController = SettingsTableViewController(user: authService.user)
        settingsTableViewController.title = "Settings"
        settingsTableViewController.delegate = self
        presenter.show(settingsTableViewController, sender: self)
    }
}

extension ProfileCoordinator: SettingsTableViewControllerDelegate {
    func showLogoutConfirm() {
        let alertController = UIAlertController(title: "Confirm Logout", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [unowned self] action in
            self.authService.endSession()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    func didSelectChangeEmail() {
        let alertController = UIAlertController(title: "Confirm Password", message: "Please re-enter password before continuing", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            guard let password = alertController.textFields?.first?.text,
                let email = self.authService.user?.email else { return }
            
            self.authService.reauthenticate(with: email, password: password, completion: { [unowned self] error in
                if let error = error {
                    self.presenter.showError(error.localizedDescription)
                } else {
                    let emailViewController = EmailViewController(email: self.authService.user?.email)
                    emailViewController.delegate = self
                    self.presenter.show(emailViewController, sender: self)
                }
            })
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        presenter.present(alertController, animated: true, completion: nil)
    }
}

extension ProfileCoordinator: EmailViewControllerDelegate {
    func cancelEmail() {
        presenter.popViewController(animated: true)
    }
    
    func saveEmail(email: String) {
        authService.updateEmail(email) { [unowned self] error in
            if let error = error {
                self.presenter.showError(error.localizedDescription)
            } else {
                self.presenter.popViewController(animated: true)
            }
        }
    }
}
