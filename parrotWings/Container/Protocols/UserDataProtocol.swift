//
//  UserDataProtocol.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

protocol UserDataProtocol {
    func setAuthToken(token: String?) -> Void
    func getAuthToken() -> String?
    func logout() -> Void
}
