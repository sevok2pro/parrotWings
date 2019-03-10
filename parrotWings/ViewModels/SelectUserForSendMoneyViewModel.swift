//
//  SelectUserForSendMoneyViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift

class SelectUserForSendMoneyViewModel: ViewModel<SelectUserForSendMoneyViewController> {
    private var searchBarInput$: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    public override func configure(view: SelectUserForSendMoneyViewController) {
        view.data = []
        view.onSearchPharseChange = { pharse in
            self.searchBarInput$.onNext(pharse)
        }
        
        _ = searchBarInput$
            .flatMapLatest({pharse -> Observable<[String]> in
                return dal.getUsers(filterPharse: pharse)
                    .map({(result: GetUsersResult) -> [String] in result.data.map({user in user.name})})
            })
            .subscribe(onNext: {(data: [String]) in
                view.data = data
                view.tableView.reloadData()
            })
    }
}

let selectUserForSendMoneyViewModel = SelectUserForSendMoneyViewModel();
