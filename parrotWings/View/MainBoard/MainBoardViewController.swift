//
//  MainBoardViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class MainBoardViewController: UIViewController {
    @IBOutlet weak var balanceField: UILabel!
    @IBAction func handleLogout(_ sender: Any) {
        self.onLogout()
    }
    var onLogout: (() -> Void)!
    var updateBalance: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainBoardViewModel.configure(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBalance()
    }
}
