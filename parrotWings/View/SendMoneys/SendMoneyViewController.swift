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
    var recipientUserUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: when will be real user id, add self.userName
        recipientUserField.text = self.recipientUserUid
    }
    
    func trySendMoney() -> Void {
        guard let amount: Int =  Int(self.amountField.text!) else {
            return
        }
        _ = dal.makeTransaction(recipientUserUid: self.recipientUserUid, amount: amount)
            .subscribe(onNext: {transactionResult in
                if(transactionResult.status == .success) {
                    self.performSegue(
                        withIdentifier: "ShowDetailTransaction",
                        sender: transactionResult.transactionId
                    )
                }
            })
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let _ = sender as? String else {
            self.trySendMoney()
            return false
        }
        return true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
