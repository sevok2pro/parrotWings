//
//  userData.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift

class UserData {
    var authToken: String? = nil
    let authTokenSubject: BehaviorSubject<String?>
    
    init() {
        self.authTokenSubject = BehaviorSubject(value: nil)
    }
    
    func observeAuthToken() -> Observable<String?> {
        return authTokenSubject.asObservable();
    }
    
    func setAuthToken(token: String){
        self.authToken = token;
        authTokenSubject.onNext(self.authToken)
    }
}

let userData = UserData();
