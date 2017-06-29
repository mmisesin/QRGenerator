//
//  ItemTableViewCell.swift
//  AdminReceiptGenerator
//
//  Created by Artem Misesin on 5/6/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityNumber: UILabel!
    
    @IBOutlet weak var incrementor: UIStepper!
    
    weak var parent: OrderViewController?
    
    var receiptItem: ReceiptItem?{
        didSet{
            quantityNumber.text = String(describing: receiptItem!.quantity)
        }
    }
    
    @IBAction func increment(_ sender: UIStepper) {
        let temp = ReceiptItem()
        temp.quantity = Int(sender.value)
        temp.price = (receiptItem?.price)!
        parent!.totalSumm -= Double(receiptItem!.quantity) * receiptItem!.price
        receiptItem = temp
        parent?.order[tag] = receiptItem!
        parent!.totalSumm += Double(receiptItem!.quantity) * receiptItem!.price
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
