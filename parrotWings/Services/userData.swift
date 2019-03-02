//
//  userData.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class UserData {
    var authToken: String? = nil;
    
    func setAuthToken(token: String){
        self.authToken = token;
    }
}

let userData = UserData();
