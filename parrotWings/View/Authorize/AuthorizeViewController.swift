//
//  AuthorizeViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class AuthorizeViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("authorize controller shown")
        // Do any additional setup after loading the view.
    }
    
    func tryAuth() {
        let email: String = self.emailField.text ?? "";
        let password: String = self.passwordField.text ?? "";
        _ = dal.authorize(login: email, password: password)
            .take(1)
            .subscribe(onNext: {next in
                if(next.status == .success && next.token != nil) {
                    userData.setAuthToken(token: next.token!)
                    self.performSegue(withIdentifier: "MoveToMainApp", sender: "authSuccess")
                }
            })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let status = sender as? String else {
            self.tryAuth()
            return false
        }
        if(status == "authSuccess") {
            return true
        }
        return false
    }
}
