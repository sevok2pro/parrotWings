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
    let name: String
    
    init(name: String) {
        self.name = name;
    }
}

class GetUsersResult {
    let data: [PublicUser];
    let hasNext: Bool = true
    
    init(filterPharse: String, portion: Int, portionSize: Int) {
        data = (portionSize * (portion - 1)..<portionSize * portion).map({name in PublicUser(name: filterPharse + "_Vasya_" + String(name))})
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
    case unknowError // TOOD: handle smt strange for retry transaction
}

class TransactionResults {
    let status: TransactionStatus
    let transactionId: String
    
    init(status: TransactionStatus = .success) {
        self.status = status
        self.transactionId = String(Int.random(in: 0..<100))
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
    
    func getUsers(filterPharse: String?, portion: Int = 1, portionSize: Int = 20) -> Observable<GetUsersResult> {
        return Observable
            .just(GetUsersResult(
                filterPharse: filterPharse ?? "",
                portion: portion,
                portionSize: portionSize
            ))
            .delay(0.2, scheduler: MainScheduler.instance)
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
                request("http://193.124.114.46:3001/api/protected/user-info", method: .get, headers: ["Authorization": "Bearer " + authToken])
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
                                        observer.onCompleted()
                                    }
                                    break;
                                }
                            }
                            break;
                        case (_, _):
                            print(response)
                            break;
                        }
                    })
                return Disposables.create()
            })
    }
    
    func makeTransaction(recipientUserUid: String, amount: Int) -> Observable<TransactionResults> {
        return Observable
            .just(TransactionResults())
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

let dal = DAL(userData: userData);
