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
    var tryCreateUser: ((_ onSuccess: @escaping () -> Void, _ onError: @escaping (_ error: String) -> Void) -> Void)!
    
    let registerViewModel: RegisterViewModel = parrotWingsContainer.container.resolve(RegisterViewModel.self)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerViewModel.configure(view: self)
    }
    
    private func successRegisterHandler() {
        self.performSegue(withIdentifier: "MoveToMainApp", sender: "registerSuccess")
    }
    
    private func errorRegisterHandler(_ error: String) {
        let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Понял", style: UIAlertAction.Style.default, handler: {_ in
            self.emailField.becomeFirstResponder()
        }))
        self.present(alert, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let status = sender as? String else {
            self.tryCreateUser(self.successRegisterHandler, self.errorRegisterHandler)

    
            return false
        }
        if(status == "registerSuccess") {
            return true
        }
        return false
    }
}
