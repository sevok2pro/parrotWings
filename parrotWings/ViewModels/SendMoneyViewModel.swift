//
//  SendMoneyViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class SendMoneyViewModel: ViewModel<SendMoneyViewController> {
    public override func configure(view: SendMoneyViewController) {
        view.recipientUserField.text = view.recipientUser.name
        
        view.trySendMoney = {(onSuccess, onFailure) in
            guard let amount: Int =  Int(view.amountField.text!) else {
                return
            }
            _ = dal.makeTransaction(recipientUserName: view.recipientUser.name, amount: amount)
                .subscribe(onNext: {transactionResult in
                    if(transactionResult.status == .success) {
                        onSuccess(String(transactionResult.transaction!.id))
                        return
                    }
                    if(transactionResult.status == .notEnouthMoney) {
                        onFailure("Недостаточно средств")
                        return
                    }
                    onFailure("Произошла неизвестная ошибка")
                })
        }
    }
}

let sendMoneyViewModel = SendMoneyViewModel()
