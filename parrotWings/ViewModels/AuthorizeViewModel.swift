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
        view.tryAuth = {onSuccess in
            print("try auth")
            let email: String = view.emailField.text ?? "";
            let password: String = view.passwordField.text ?? "";
            _ = dal.authorize(login: email, password: password)
                .subscribe(onNext: {next in
                    userData.setAuthToken(token: next.token!)
                    onSuccess()
                })
        }
//        view.tryAuth = {onSuccess in {
//
//            let email: String = view.emailField.text ?? "";
//            let password: String = view.passwordField.text ?? "";
//            _ = dal.authorize(login: email, password: password)
//                .take(1)
//                .subscribe(onNext: {next in
//                    onSuccess();
//                    if(next.status == .success && next.token != nil) {
//                        userData.setAuthToken(token: next.token!)
//                        self.performSegue(withIdentifier: "MoveToMainApp", sender: "authSuccess")
//                    }
//                })
//        }}
    }
}

let authorizeViewModel = AuthorizeViewModel()
