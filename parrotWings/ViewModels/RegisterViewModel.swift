//
//  RegisterViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class RegisterViewModel: ViewModel<RegisterViewController> {
    private var passwordsIsNotEqual: Bool = false;
    
    private func checkPasswordsForEquals(main: String, sub: String) -> Bool {
        if(main == sub) {
            self.passwordsIsNotEqual = false
            return true
        } else {
            self.passwordsIsNotEqual = true
            return false
        }
    }
    
    override func configure(view: RegisterViewController) {
        self.passwordsIsNotEqual = false
        view.onChangeMainPassword = {() in
            view.alertMessage.isHidden = self.checkPasswordsForEquals(
                main: view.passwordField.text ?? "",
                sub: view.subPasswordField.text ?? ""
            )
        }
        view.onChangeSubPassword = {() in
            view.alertMessage.isHidden = self.checkPasswordsForEquals(
                main: view.passwordField.text ?? "",
                sub: view.subPasswordField.text ?? ""
            )
        }
        view.tryCreateUser = {(onComplete, onError) in
            if(self.passwordsIsNotEqual == true) {
                return;
            }
            let email: String = view.emailField.text ?? "";
            let password: String = view.passwordField.text ?? "";
            _ = dal.createUser(login: email, password: password)
                .subscribe(onNext: {next in
                    switch next.status {
                    case .success:
                        userData.setAuthToken(token: "lol")
                        onComplete()
                        break;
                    case .emptyUserData:
                        onError("Введите e-mail")
                        break;
                    case .duplicateEmail:
                        onError("Текущий e-mail уже используется")
                        break;
                    case _:
                        onError("Произошла неизвестная ошибка")
                    }
                })
        }
    }
}

let registerViewModel = RegisterViewModel()
