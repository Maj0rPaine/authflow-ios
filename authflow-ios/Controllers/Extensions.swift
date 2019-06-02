//
//  Extensions.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/2/19.
//

import UIKit

extension UIViewController {
    func showError(_ error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
