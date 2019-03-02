//
//  UserBalanceService.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift

class UserBalanceService {
    let userBalance$: Observable<String>;
    let updateSignals$: BehaviorSubject = BehaviorSubject(value: true)
    init(userData: UserData) {
        self.userBalance$ = Observable
            .combineLatest(
                userData.observeAuthToken(),
                updateSignals$.asObservable()
            )
            .flatMapLatest({(token, updateSignal) in
                return dal.getUserBalance(token: token!)
            })
    }
    
    func observeUserBalance() -> Observable<String> {
        return self.userBalance$
            .asObservable()
    }
    
    func updateUserBalance() {
        self.updateSignals$.onNext(true)
    }
}

let userBalanceService = UserBalanceService(userData: userData)
