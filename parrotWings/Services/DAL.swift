//
//  dal.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class PublicUser {
    public let name: String
    public let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

enum GetUserResultStatus {
    case success
    case emptyPharse
    case unknowError
}

class GetUsersResult {
    public let data: [PublicUser]
    public let status: GetUserResultStatus
    
    init(data: [PublicUser], status: GetUserResultStatus) {
        self.data = data
        self.status = status
    }
}

enum AuthorizeStatus {
    case success
    case incorrectAuthData
    case emptyAuthData
    case unknowError
}

class AuthorizeResult {
    let status: AuthorizeStatus;
    let token: String?;
    
    init(status: AuthorizeStatus, token: String? = nil) {
        self.status = status
        self.token = status == .success && token != nil ? token : nil
    }
}

enum CreateUserStatus {
    case success
    case emptyUserData
    case duplicateEmail
    case unknowError
}

class CreateUserResult {
    let status: CreateUserStatus
    let token: String?
    
    init(status: CreateUserStatus, token: String? = nil) {
        self.status = status
        self.token = status == .success && token != nil ? String(Int.random(in: 0..<100)) : nil
    }
}

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

class DAL {
    private let userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
    }
    
    func getUsers(filterPharse: String?) -> Observable<GetUsersResult> {
        guard let authToken: String = userData.getAuthToken() else {
            return Observable.empty()
        }
        let filter: String = filterPharse ?? ""
        return Observable<GetUsersResult>
            .create({observer in
                request(
                        "http://193.124.114.46:3001/api/protected/users/list",
                        method: .post,
                        parameters: ["filter": filter],
                        headers: ["Authorization": "Bearer " + authToken]
                    )
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        
                        switch response {
                        case (200, _):
                            let jsonArray = try? JSONSerialization.jsonObject(with: result.data ?? Data(), options: [])
                            if let array = jsonArray as? [Any] {
                                if let arrayOfUsers: Array<[String: Any]> = array as? Array<[String: Any]> {
                                    var userData: Array<PublicUser> = []
                                    for user in arrayOfUsers {
                                        userData.append(PublicUser(name: user["name"] as! String, id: user["id"] as! Int))
                                    }
                                    observer.onNext(GetUsersResult(data: userData,status: .success))
                                }
                            }
                            break;
                        case (401, "No search string."):
                            observer.onNext(GetUsersResult(data: [], status: .emptyPharse))
                            break;
                        case (_, _):
                            print(response)
                        }
                        
                        observer.onCompleted()
                    })
                return Disposables.create()
            })
    }
    
    
    func authorize(login: String, password: String) -> Observable<AuthorizeResult> {
        let params = [
            "email": login,
            "password": password,
        ]
        
        return Observable<AuthorizeResult>
            .create({observer in
                request("http://193.124.114.46:3001/sessions/create", method: .post, parameters: params)
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        switch response {
                        case (201, _):
                            let data: Data = result.data ?? Data()
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = json as? [String: Any] {
                                if let token = dictionary["id_token"] as? String {
                                    observer.onNext(AuthorizeResult(status: .success, token: token))
                                    break;
                                } else {
                                    // print("not found key id_token in dictionary")
                                }
                            } else {
                                // print("not cast value")
                            }
                            observer.onNext(AuthorizeResult(status: .unknowError))
                            break;
                        case (400, "You must send email and password."):
                            observer.onNext(AuthorizeResult(status: .emptyAuthData))
                            break;
                        case (401, "Invalid email or password."):
                            observer.onNext(AuthorizeResult(status: .incorrectAuthData))
                            break;
                        case (_, _):
                            observer.onNext(AuthorizeResult(status: .unknowError))
                            break;
                        }
                        observer.onCompleted()
                    })
                
                return Disposables.create()
            })
    }
    
    func createUser(login: String, password: String) -> Observable<CreateUserResult> {
        let params = [
            "username": login,
            "email": login,
            "password": password,
        ]
        
        return Observable<CreateUserResult>
            .create({observer in
                request("http://193.124.114.46:3001/users", method: .post, parameters: params)
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)

                        switch response {
                        case (201, _):
                            let data: Data = result.data ?? Data()
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = json as? [String: Any] {
                                if let token = dictionary["id_token"] as? String {
                                    observer.onNext(CreateUserResult(status: .success, token: token))
                                    break;
                                } else {
                                    // print("not found key id_token in dictionary")
                                }
                            } else {
                                // print("not cast value")
                            }
                            observer.onNext(CreateUserResult(status: .unknowError))
                            break;
                        case (400, "A user with that email exists"):
                            observer.onNext(CreateUserResult(status: .duplicateEmail))
                            break;
                        case (400, "You must send username and password"):
                            observer.onNext(CreateUserResult(status: .emptyUserData))
                            break;
                        case (_, _):
                            observer.onNext(CreateUserResult(status: .unknowError))
                            break;
                        }
                        observer.onCompleted()
                    })
                
                return Disposables.create()
            })
    }
    
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
    
    func makeTransaction(recipientUserName: String, amount: Int) -> Observable<TransactionResult> {
        guard let authToken: String = userData.getAuthToken() else {
            print("bad token")
            return Observable.empty()
        }
        return Observable<TransactionResult>
            .create({observer in
                request(
                        "http://193.124.114.46:3001/api/protected/transactions",
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
                            print(response)
                            break;
                        }
                        
                        
                        observer.onCompleted()
                    })
                return Disposables.create()
            })
    }
}

let dal = DAL(userData: userData);
