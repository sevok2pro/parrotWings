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
        view.tryCreateUser = {(onComplete) in
            let email: String = view.emailField.text ?? "";
            let password: String = view.passwordField.text ?? "";
            _ = dal.createUser(login: email, password: password)
                .take(1)
                .subscribe(onNext: {next in
                    if(next.status == .success && next.token != nil) {
                        userData.setAuthToken(token: next.token!)
                        onComplete()
                    }
                })
        }
    }
}

let registerViewModel = RegisterViewModel()
