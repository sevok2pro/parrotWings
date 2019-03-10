//
//  makeTransaction.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum TransactionStatus {
    case success
    case notEnouthMoney
    case unknowError
}

class Transaction {
    let id: Int
    let date: String
    let userName: String
    let amount: Int
    let balance: Int
    
    init(id: Int, date: String, userName: String, amount: Int, balance: Int) {
        self.id = id
        self.date = date
        self.userName = userName
        self.amount = amount
        self.balance = balance
    }
}

class TransactionResult {
    let status: TransactionStatus
    let transaction: Transaction?
    
    init(status: TransactionStatus, transaction: Transaction? = nil) {
        self.status = status
        self.transaction = transaction
    }
}

extension DAL {
    func makeTransaction(recipientUserName: String, amount: Int) -> Observable<TransactionResult> {
        guard let authToken: String = userData.getAuthToken() else {
            print("bad token")
            return Observable.empty()
        }
        return Observable<TransactionResult>
            .create({observer in
                request(
                    "\(self.serverPath)/api/protected/transactions",
                    method: .post,
                    parameters: ["name": recipientUserName, "amount": amount],
                    headers: ["Authorization": "Bearer " + authToken]
                    ).response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        
                        switch response {
                        case (200, _):
                            let json = try? JSONSerialization.jsonObject(with: result.data ?? Data(), options: [])
                            if let dictionary = json as? [String: Any] {
                                guard let transactionData = dictionary["trans_token"] as? [String: Any] else {
                                    return
                                }
                                guard let id = transactionData["id"] as? Int else {
                                    return
                                }
                                guard let date = transactionData["date"] as? String else {
                                    return
                                }
                                guard let userName = transactionData["username"] as? String else {
                                    return
                                }
                                guard let amount = transactionData["amount"] as? Int else {
                                    return
                                }
                                guard let balance = transactionData["balance"] as? Int else {
                                    return
                                }
                                let transaction = Transaction(id: id, date: date, userName: userName, amount: amount, balance: balance)
                                let transactionResult = TransactionResult(status: .success, transaction: transaction)
                                observer.onNext(transactionResult)
                            }
                            break;
                        case (400, "Balance exceeded. Transaction is impossible"):
                            observer.onNext(TransactionResult(status: .notEnouthMoney))
                            break;
                        case (_, _):
                            observer.onNext(TransactionResult(status: .unknowError))
                            break;
                        }
                        
                        
                        observer.onCompleted()
                    })
                return Disposables.create()
            })
    }
}
