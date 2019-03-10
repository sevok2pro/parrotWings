//
//  dal.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class DAL {
    private let userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
    }
}

let dal = DAL(userData: userData);
