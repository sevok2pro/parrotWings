//
//  Container.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import Swinject

class ParrotWingsContainer {
    public let container = Container()
    init() {
        self.container.register(UserData.self, factory: {_ in UserData()}).inObjectScope(.container)
        self.container.register(DAL.self, factory: {r in DAL(userData: r.resolve(UserData.self)!)}).inObjectScope(.container)
        
        self.container.register(MainBoardViewModel.self, factory: {r in
            return MainBoardViewModel(
                dal: r.resolve(DAL.self)!,
                userData: r.resolve(UserData.self)!
            )
        })
        self.container.register(AuthorizeViewModel.self, factory: {r in
            return AuthorizeViewModel(
                userData: r.resolve(UserData.self)!,
                dal: r.resolve(DAL.self)!
            )
        })
        self.container.register(RegisterViewModel.self, factory: {r in
            return RegisterViewModel(
                userData: r.resolve(UserData.self)!,
                dal: r.resolve(DAL.self)!
            )
        })
        self.container.register(SelectUserForSendMoneyViewModel.self, factory: {r in
            return SelectUserForSendMoneyViewModel(dal: r.resolve(DAL.self)!)
        })
        self.container.register(SendMoneyViewModel.self, factory: {r in
            SendMoneyViewModel(
                dal: r.resolve(DAL.self)!
            )
        })
    }
}

let parrotWingsContainer = ParrotWingsContainer()
