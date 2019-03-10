//
//  SendMoneyViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 02/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class SuccessTransaction{
    public let transactionId: String
    
    init(transactionId: String) {
        self.transactionId = transactionId
    }
}

class SendMoneyViewController: UIViewController {
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var recipientUserField: UILabel!
    // variable from previous view
    var recipientUser: PublicUser!
    // from viewModel
    var trySendMoney: ((_ onSuccess: @escaping (_ transactionId: String) -> Void, _ onFailure: @escaping (_ error: String) -> Void) -> Void)!
    
    let sendMoneyViewModel: SendMoneyViewModel = parrotWingsContainer.container.resolve(SendMoneyViewModel.self)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendMoneyViewModel.configure(view: self)
    }
    
    func handleSuccessTransaction(transactionId: String) {
        self.performSegue(
            withIdentifier: "ShowDetailTransaction",
            sender: SuccessTransaction(transactionId: transactionId)
        )
    }
    
    func handleFailureTransaction(error: String) -> Void {
        let alert = UIAlertController(title: "Ошибка!", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Понял", style: UIAlertAction.Style.default, handler: {_ in
            self.amountField.becomeFirstResponder()
        }))
        self.present(alert, animated: true)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let _ = sender as? SuccessTransaction else {
            self.trySendMoney(handleSuccessTransaction, handleFailureTransaction)
            return false
        }
        return true
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailTransactionView = segue.destination as? TransactionDetailViewController else {
            fatalError("incorrect view controller")
        }
        guard let transaction = sender as? SuccessTransaction else {
            fatalError("incorrect transaction id")
        }
        detailTransactionView.transactionId = transaction.transactionId
    }
}
