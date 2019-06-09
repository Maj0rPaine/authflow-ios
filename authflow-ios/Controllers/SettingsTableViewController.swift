//
//  SettingsTableViewController.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/3/19.
//

import UIKit

protocol SettingsTableViewControllerDelegate: class {
    func showLogoutConfirm()
    func didSelectChangeEmail()
}

class SettingsTableViewController: UITableViewController {
    weak var delegate: SettingsTableViewControllerDelegate?
    
    private var user: AuthUser?

    convenience init(user: AuthUser?) {
        self.init(style: .grouped)
        self.user = user
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(confirmLogout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Email"
        cell.detailTextLabel?.text = user?.email
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectChangeEmail()
    }
    
    @objc func confirmLogout() {
        delegate?.showLogoutConfirm()
    }
}
