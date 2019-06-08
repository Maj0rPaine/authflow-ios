//
//  ProfileCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/2/19.
//

import UIKit
import Firebase

/// Coordinates access to profile
class ProfileCoordinator: Coordinator {
    weak var delegate: AuthCoordinatorDelegate?
    
    let profileViewController: ProfileViewController
        
    private let presenter: UINavigationController
    
    private var user: User?
    
    init(presenter: UINavigationController, user: User) {
        self.presenter = presenter
        self.user = user
        
        profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        profileViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(showSettings))
    }
    
    func start() {
        presenter.viewControllers = [profileViewController]
        presenter.isNavigationBarHidden = false
    }
    
    @objc func showSettings() {
        let settingsTableViewController = SettingsTableViewController(user: user)
        settingsTableViewController.title = "Settings"
        settingsTableViewController.delegate = self
        presenter.show(settingsTableViewController, sender: self)
    }
}

extension ProfileCoordinator: SettingsTableViewControllerDelegate {
    func showLogoutConfirm() {
        let alertController = UIAlertController(title: "Confirm Logout", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [unowned self] action in
            self.delegate?.endSession()
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
                let email = self.user?.email else { return }

            self.user?.reauthenticateAndRetrieveData(with: EmailAuthProvider.credential(withEmail: email, password: password), completion: { (authDataResult, error) in
                guard let user = authDataResult?.user, error == nil else {
                    self.presenter.showError(error?.localizedDescription ?? "Error")
                    return
                }

                let emailViewController = EmailViewController(email: user.email)
                emailViewController.delegate = self
                self.presenter.show(emailViewController, sender: self)
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
        user?.updateEmail(to: email) { [unowned self] error in
            if let error = error {
                self.presenter.showError(error.localizedDescription)
            } else {
                self.presenter.popViewController(animated: true)
            }
        }
    }
}
