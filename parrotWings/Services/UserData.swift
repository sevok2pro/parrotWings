//
//  userData.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import KeychainAccess

class UserData {
    private var authToken: String? = nil
    private let keychain = Keychain(service: "com.parrotWings")
    
    init() {
        do {
            guard let token: String = try keychain.get("authToken") else {
                return;
            }
            self.setAuthToken(token: token)
        } catch let error {
            print(error)
        }
    }
    
    public func setAuthToken(token: String?) -> Void {
        self.authToken = token
        do {
            guard let stringToken: String = token else {
                try keychain.remove("authToken")
                return
            }
            try keychain.set(stringToken, key: "authToken")
        } catch let error {
            print(error)
            return
        }
    }
    
    public func getAuthToken() -> String? {
        return self.authToken
    }
    
    public func logout() -> Void {
        self.setAuthToken(token: nil)
    }
}
