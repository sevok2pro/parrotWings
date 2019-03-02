//
//  dal.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift

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
    case incorrectUser
}

class AuthorizeResult {
    let status: AuthorizeStatus;
    let token: String?;
    
    init(status: AuthorizeStatus) {
        self.status = status
        self.token = status == .success ? String(Int.random(in: 0..<100)) : nil
    }
}

enum CreateUserStatus {
    case success
    case emailAlredyUsed
    case incorrectEmail
    case weakEmail
}

class CreateUserResult {
    let status: CreateUserStatus
    let token: String?
    
    init(status: CreateUserStatus) {
        self.status = status
        self.token = status == .success ? String(Int.random(in: 0..<100)) : nil
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

class DAL {
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
        return Observable
            .just(AuthorizeResult(status: .success))
            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func createUser(login: String, password: String) -> Observable<CreateUserResult> {
        return Observable
            .just(CreateUserResult(status: .success))
            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func getUserBalance(token: String) -> Observable<String> {
        return Observable
            .just(String(Int.random(in: 0..<10000)))
            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func makeTransaction(recipientUserUid: String, amount: Int) -> Observable<TransactionResults> {
        return Observable
            .just(TransactionResults())
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

let dal = DAL();
