//
//  MainBoardViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class MainBoardViewModel: ViewModel<MainBoardViewController> {
    private var userBalanceService: UserBalanceService
    
    init(userBalanceService: UserBalanceService) {
        self.userBalanceService = userBalanceService
    }
    
    public override func configure(view: MainBoardViewController) {
        _ = self.userBalanceService.observeUserBalance()
            .subscribe(onNext: {balance in
                view.balanceField.text = balance
            })
    }
}

let mainBoardViewModel = MainBoardViewModel(userBalanceService: userBalanceService)
