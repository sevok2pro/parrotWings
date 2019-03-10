//
//  SelectUserForSendMoneyViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit
import RxSwift

class SelectUserForSendMoneyViewController: UITableViewController, UISearchBarDelegate {
    var data: [PublicUser]!
    var onSearchPharseChange: ((_ searchPharse: String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectUserForSendMoneyViewModel.configure(view: self)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? SelectUserForSendMoneyViewControllerTableViewCell else {
            fatalError("can not view this cell type")
        }
        cell.userName.text = data[indexPath.row].name
        cell.user = data[indexPath.row]
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.onSearchPharseChange(searchText)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? SelectUserForSendMoneyViewControllerTableViewCell else {
            fatalError("bad cell")
        }
        guard let sendMoneyView = segue.destination as? SendMoneyViewController else {
            fatalError("incorrect view destinition")
        }
        sendMoneyView.recipientUser = cell.user;
    }
}
