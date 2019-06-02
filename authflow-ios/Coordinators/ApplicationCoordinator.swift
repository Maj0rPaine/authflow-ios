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
    
    var authCoordinator: AuthCoordinator?

    var profileCoordinator: ProfileCoordinator?
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let splashViewController = SplashViewController()
        splashViewController.delegate = self
        rootViewController.viewControllers = [splashViewController]
    }
}

extension ApplicationCoordinator: AuthCoordinatorDelegate {
    func authSuccess() {
        profileCoordinator = ProfileCoordinator(presenter: rootViewController)
        profileCoordinator?.delegate = self
        profileCoordinator?.start()
    }
    
    func authFailure() {
        authCoordinator = AuthCoordinator(presenter: rootViewController)
        authCoordinator?.delegate = self
        authCoordinator?.start()
    }
    
    func endSession() {
        authFailure()
    }
}
