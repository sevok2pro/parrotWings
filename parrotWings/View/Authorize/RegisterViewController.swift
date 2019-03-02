//
//  RegisterViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    var passwordsIsNotEqual: Bool = false;
    
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var subPasswordField: UITextField!
    @IBAction func changeOriginPassword(_ sender: Any) {
        if(self.subPasswordField.hasText){
            self.checkPasswordsForEquals()
        }
    }
    @IBAction func changeSubPassword(_ sender: Any) {
        if(self.passwordField.hasText) {
            self.checkPasswordsForEquals()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func checkPasswordsForEquals() {
        let main: String = self.passwordField.text ?? ""
        let sub: String = self.subPasswordField.text ?? ""
        
        if(main == sub) {
            self.passwordsIsNotEqual = false
            self.alertMessage.isHidden = true
        } else {
            self.passwordsIsNotEqual = true
            self.alertMessage.isHidden = false
        }
    }
    
    func tryCreateUser() {
        let email: String = self.emailField.text ?? "";
        let password: String = self.passwordField.text ?? "";
        _ = dal.createUser(login: email, password: password)
            .take(1)
            .subscribe(onNext: {next in
                if(next.status == .success && next.token != nil) {
                    userData.setAuthToken(token: next.token!)
                    self.performSegue(withIdentifier: "MoveToMainApp", sender: "registerSuccess")
                }
            })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let status = sender as? String else {
            self.tryCreateUser()
            return false
        }
        if(status == "registerSuccess") {
            return true
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
