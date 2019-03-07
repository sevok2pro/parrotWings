//
//  RegisterViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var subPasswordField: UITextField!
    @IBAction func changeOriginPassword(_ sender: Any) {
        self.onChangeMainPassword();
    }
    @IBAction func changeSubPassword(_ sender: Any) {
        self.onChangeSubPassword();
    }
    
    // ViewModelFields
    var onChangeMainPassword: (() -> Void)!
    var onChangeSubPassword: (() -> Void)!
    var tryCreateUser: ((_ onSuccess: @escaping () -> Void) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel.configure(view: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let status = sender as? String else {
            self.tryCreateUser({() in
                self.performSegue(withIdentifier: "MoveToMainApp", sender: "registerSuccess")
            })
            return false
        }
        if(status == "registerSuccess") {
            return true
        }
        return false
    }
}
