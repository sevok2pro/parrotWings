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
        view.recipientUserField.text = view.recipientUserUid
        
        view.trySendMoney = {onSuccess in
            guard let amount: Int =  Int(view.amountField.text!) else {
                return
            }
            _ = dal.makeTransaction(recipientUserUid: view.recipientUserUid, amount: amount)
                .subscribe(onNext: {transactionResult in
                    if(transactionResult.status == .success) {
                        onSuccess(transactionResult.transactionId)
                    }
                })
        }
    }
}

let sendMoneyViewModel = SendMoneyViewModel()
