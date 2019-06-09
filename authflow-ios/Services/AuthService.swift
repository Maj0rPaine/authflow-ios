//
//  AuthService.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/8/19.
//

import Foundation
import Firebase

typealias AuthUser = User

/// Handle auth requests and session
protocol AuthServiceDelegate: class {
    /// Successful auth request for user
    func authSuccess()
    /// Failed auth request
    func authFailure()
    /// Expire auth session
    func endSession()
}

class AuthService {
    weak var delegate: AuthServiceDelegate?
    
    var user: AuthUser?
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        FirebaseApp.configure()
    }
    
    func getUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                self.delegate?.authFailure()
                return
            }
            
            self.user = user
            self.delegate?.authSuccess()
        }
    }
    
    func login(with email: String, password: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            guard let user = authDataResult?.user, error == nil else {
                completion(error)
                return
            }
            self.user = user
            self.delegate?.authSuccess()
        }
    }
    
    func signup(with email: String, password: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                completion(error)
                return
            }
            self.user = user
            self.delegate?.authSuccess()
        }
    }
    
    func signout() throws {
        try Auth.auth().signOut()
    }
    
    func endSession() {
        delegate?.endSession()
    }
    
    func reauthenticate(with email: String, password: String, completion: @escaping (Error?) -> ()) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        self.user?.reauthenticateAndRetrieveData(with: credential, completion: { (authDataResult, error) in
            completion(error)
        })
    }
    
    func updateEmail(_ email: String, completion: @escaping (Error?) -> ()) {
        self.user?.updateEmail(to: email) { error in
            completion(error)
        }
    }
}
