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
    
    var tryAuth: ((_ onSuccess: @escaping () -> Void, _ onFailure: @escaping (_ error: String) -> Void) -> Void)!
    var checkForNeedAuth: ((_ onAlredyAuth: @escaping () -> Void) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        authorizeViewModel.configure(view: self)
        self.checkForNeedAuth({() in
            self.handleSuccessAuth()
        })
    }
    
    func handleSuccessAuth() {
        self.performSegue(withIdentifier: "MoveToMainApp", sender: "authSuccess")
    }
    
    func handleFailureAuth(_ error: String) {
        let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Понял", style: UIAlertAction.Style.default, handler: {_ in
            self.emailField.becomeFirstResponder()
        }))
        self.present(alert, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let status = sender as? String else {
            self.tryAuth(self.handleSuccessAuth, self.handleFailureAuth)
            return false
        }
        if(status == "authSuccess") {
            return true
        }
        return false
    }
}
