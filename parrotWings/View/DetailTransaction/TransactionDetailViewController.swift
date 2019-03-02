//
//  TransactionDetailViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {
    
    @IBOutlet weak var transactionNumberField: UILabel!
    var transactionId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transactionNumberField.text = "Статус транзакции №" + self.transactionId
        // Do any additional setup after loading the view.
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
