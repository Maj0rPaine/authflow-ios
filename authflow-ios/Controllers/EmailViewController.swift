//
//  EmailViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/3/19.
//

import UIKit

protocol EmailViewControllerDelegate: class {
    func cancelEmail()
    func saveEmail(email: String)
}

class EmailViewController: BaseViewController {
    weak var delegate: EmailViewControllerDelegate?
    
    private var email: String?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = email
        textField.clearButtonMode = .whileEditing
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.becomeFirstResponder()
        return textField
    }()
    
    convenience init(email: String?) {
        self.init()
        self.email = email
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelEmail))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEmail))
    }
    
    override func loadView() {
        self.view = tableView
    }
    
    @objc func cancelEmail() {
        delegate?.cancelEmail()
    }
    
    @objc func saveEmail() {
        guard let email = textField.text else { return }
        delegate?.saveEmail(email: email)
    }
}

extension EmailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Email"
        cell.contentView.addSubview(textField)
        cell.contentView.addConstraints([
            textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        return cell
    }
}
