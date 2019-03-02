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
}

let dal = DAL();
