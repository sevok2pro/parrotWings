//
//  TableViewCell.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit

class SelectUserForSendMoneyViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    var user: PublicUser!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
