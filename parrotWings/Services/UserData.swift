//
//  userData.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift
import KeychainAccess

class UserData {
    private var authToken: String? = nil
    private let authTokenSubject: BehaviorSubject<String?>
    private let keychain = Keychain(service: "com.parrotWings")
    
    init() {
        self.authTokenSubject = BehaviorSubject(value: nil)
        do {
            let token: String = try keychain.get("authToken")!
            self.authTokenSubject.onNext(token)
        } catch let error {
            print(error)
        }
    }
    
    public func observeAuthToken() -> Observable<String?> {
        return authTokenSubject.asObservable();
    }
    
    public func setAuthToken(token: String) -> Void {
        self.authToken = token;
        do {
            try keychain.set(token, key: "authToken")
        } catch let error {
            print(error)
            return;
        }
        authTokenSubject.onNext(self.authToken)
    }
}

let userData = UserData();
