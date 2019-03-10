//
//  dal.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class DAL {
    public let userData: UserData
    public let serverPath: String = "http://193.124.114.46:3001"
    
    init(userData: UserData) {
        self.userData = userData
    }
}

let dal = DAL(userData: userData)
