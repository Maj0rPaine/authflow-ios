//
//  ApplicationCoordinator.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/1/19.
//

import UIKit

/// Root coordinator for application
class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    
    let authService: AuthService
    
    var authCoordinator: AuthCoordinator?

    var profileCoordinator: ProfileCoordinator?
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    init(window: UIWindow, authService: AuthService) {
        self.window = window
        self.authService = authService

        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
        
        authService.delegate = self
        authService.getUser()
    }
    
    func start() {
        rootViewController.viewControllers = [SplashViewController()]
    }
}

extension ApplicationCoordinator: AuthServiceDelegate {
    func authSuccess() {
        profileCoordinator = ProfileCoordinator(presenter: rootViewController, authService: authService)
        rootViewController.isNavigationBarHidden = false
        profileCoordinator?.start()
    }
    
    func authFailure() {
        authCoordinator = AuthCoordinator(presenter: rootViewController, authService: authService)
        rootViewController.isNavigationBarHidden = true
        authCoordinator?.start()
    }
    
    func endSession() {
        do {
            try authService.signout()
            authFailure()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
