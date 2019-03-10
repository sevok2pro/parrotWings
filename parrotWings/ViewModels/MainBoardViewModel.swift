//
//  MainBoardViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class MainBoardViewModel: ViewModel<MainBoardViewController> {
    private let dal: DAL
    private let userData: UserData
    
    init(dal: DAL, userData: UserData) {
        self.dal = dal
        self.userData = userData
    }
    
    public override func configure(view: MainBoardViewController) {
        view.onLogout = {() in
            self.userData.logout()
        }
        view.updateBalance = {() in
            _ = self.dal.getUserBalance()
                .subscribe(onNext: {(result: UserBalanceResult) in
                    if(result.status == .badToken) {
                        print("require redirect to auth page")
                        return;
                    }
                    guard let balance: Int = result.balance else {
                        return;
                    }
                    let balanceText: String = String(balance) + " PW"
                    view.balanceField.text = balanceText
                })
        }
    }
}
