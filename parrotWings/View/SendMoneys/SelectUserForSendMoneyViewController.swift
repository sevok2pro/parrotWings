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

    var data: [String] = []

    var searchBarInput$: BehaviorSubject<String> = BehaviorSubject(value: "")
    var scrollInput$: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = searchBarInput$
            .flatMapLatest({pharse -> Observable<[String]> in
                var portion: Int = 0;
                return self.scrollInput$
                    .flatMapFirst({event -> Observable<GetUsersResult> in
                        portion = portion + 1
                        return dal.getUsers(filterPharse: pharse, portion: portion)
                    })
                    .takeWhile({(result: GetUsersResult) -> Bool in result.hasNext})
                    .map({(result: GetUsersResult) -> [String] in result.data.map({user in user.name})})
                    .scan([], accumulator: {(acc: [String], next: [String]) -> [String] in acc + next})
            })
            .subscribe(onNext: {(data: [String]) in
                self.data = data
                self.tableView.reloadData()
            })
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
        self.searchBarInput$.onNext(searchText)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = Float(scrollView.contentSize.height)
        let contentScroll = Float(scrollView.contentOffset.y + scrollView.frame.size.height)
        if(contentScroll / contentHeight > 1) {
            self.scrollInput$.onNext(true)
        }
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
