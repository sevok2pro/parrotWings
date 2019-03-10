//
//  getUserBalance.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum UserBalanceStatus {
    case success
    case badToken
    case unknowError
}

class UserBalanceResult {
    public let status: UserBalanceStatus
    public let balance: Int?
    
    init(status: UserBalanceStatus, balance: Int? = nil) {
        self.status = status
        self.balance = status == .success ? balance : nil
    }
}

extension DAL {
    func getUserBalance() -> Observable<UserBalanceResult> {
        guard let authToken: String = userData.getAuthToken() else {
            return Observable.just(UserBalanceResult(status: .badToken))
        }
        return Observable<UserBalanceResult>
            .create({observer in
                request(
                    "http://193.124.114.46:3001/api/protected/user-info",
                    method: .get,
                    headers: ["Authorization": "Bearer " + authToken]
                    )
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        switch response {
                        case (200, _):
                            let data: Data = result.data ?? Data()
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = json as? [String: Any] {
                                if let userInfo = dictionary["user_info_token"] as? [String: Any] {
                                    if let balance = userInfo["balance"] as? Int {
                                        observer.onNext(UserBalanceResult(status: .success, balance: balance))
                                    }
                                    break;
                                }
                            }
                            break;
                        case (_, _):
                            observer.onNext(UserBalanceResult(status: .badToken))
                            break;
                        }
                        observer.onCompleted()
                    })
                return Disposables.create()
            })
    }
}
