//
//  AuthorizeViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class AuthorizeViewModel: ViewModel<AuthorizeViewController> {
    public override func configure(view: AuthorizeViewController) {
        view.tryAuth = {(onSuccess, onFailure) in
            let email: String = view.emailField.text ?? "";
            let password: String = view.passwordField.text ?? "";
            _ = dal.authorize(login: email, password: password)
                .subscribe(onNext: {next in
                    switch next.status {
                    case .success:
                        guard let token: String = next.token else {
                            onFailure("Произошла неизвестная ошибка")
                            return;
                        }
                        userData.setAuthToken(token: token)
                        onSuccess()
                        break;
                    case .emptyAuthData:
                        onFailure("Введите логин и пароль")
                        break;
                    case .incorrectAuthData:
                        onFailure("Неверный логин или пароль")
                        break;
                    case _:
                        onFailure("Произошла неизвестная ошибка")
                    }
                })
        }
    }
}

let authorizeViewModel = AuthorizeViewModel()
