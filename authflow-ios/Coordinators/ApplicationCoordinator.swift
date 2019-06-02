//
//  ApplicationCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit
import Firebase

/// Root coordinator for application
class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    
    var authCoordinator: AuthCoordinator?

    var profileCoordinator: ProfileCoordinator?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
        
        handle = Auth.auth().addStateDidChangeListener { [unowned self] (auth, user) in
            guard let user = user else {
                self.authFailure()
                return
            }
            
            self.authSuccess(user: user)
        }
    }
    
    func start() {
        rootViewController.viewControllers = [SplashViewController()]
    }
}

extension ApplicationCoordinator: AuthCoordinatorDelegate {
    func authSuccess(user: User) {
        profileCoordinator = ProfileCoordinator(presenter: rootViewController, user: user)
        profileCoordinator?.delegate = self
        profileCoordinator?.start()
    }
    
    func authFailure() {
        authCoordinator = AuthCoordinator(presenter: rootViewController)
        authCoordinator?.delegate = self
        authCoordinator?.start()
    }
    
    func endSession() {
        do {
            try Auth.auth().signOut()
            authFailure()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
