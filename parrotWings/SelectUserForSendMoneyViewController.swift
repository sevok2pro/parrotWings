//
//  SelectUserForSendMoneyViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class SelectUserForSendMoneyViewController: UITableViewController, UISearchBarDelegate {

    var data: [String] = ["aaaaaaaaaaa", "bbbbbbbbb", "ccccccccc"]
    var filteredData: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
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
        cell.userName.text = data[indexPath.row];
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
