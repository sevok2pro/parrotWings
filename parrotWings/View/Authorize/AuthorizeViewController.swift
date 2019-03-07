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
    
    var tryAuth: ((_ onSuccess: @escaping () -> Void) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        authorizeViewModel.configure(view: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let status = sender as? String else {
            self.tryAuth({() in
                self.performSegue(withIdentifier: "MoveToMainApp", sender: "authSuccess")
            })
            return false
        }
        if(status == "authSuccess") {
            return true
        }
        return false
    }
}
