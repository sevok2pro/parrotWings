//
//  SendMoneyViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class SendMoneyViewController: UIViewController {
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var recipientUserField: UILabel!
    // variable from previous view
    var recipientUserUid: String!
    // from viewModel
    var trySendMoney: ((_ onSuccess: @escaping (_ transactionId: String) -> Void) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMoneyViewModel.configure(view: self)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let _ = sender as? String else {
            self.trySendMoney({transactionId in
                self.performSegue(
                    withIdentifier: "ShowDetailTransaction",
                    sender: transactionId
                )
            })
            return false
        }
        return true
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let detailTransactionView = segue.destination as? TransactionDetailViewController else {
            fatalError("incorrect view controller")
        }
        guard let transactionId = sender as? String else {
            fatalError("incorrect transaction id")
        }
        detailTransactionView.transactionId = transactionId
    }
}
