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
    private var scrollInput$: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    public override func configure(view: SelectUserForSendMoneyViewController) {
        view.data = []
        view.onNeedMoreUsers = { () in
            self.scrollInput$.onNext(true)
        }
        view.onSearchPharseChange = { pharse in
            self.searchBarInput$.onNext(pharse)
        }
        
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
                view.data = data
                view.tableView.reloadData()
            })
    }
}

let selectUserForSendMoneyViewModel = SelectUserForSendMoneyViewModel();
