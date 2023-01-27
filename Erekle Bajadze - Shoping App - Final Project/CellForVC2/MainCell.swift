//
//  MainCell.swift
//  Erekle Bajadze - Shoping App - Final Project
//
//  Created by Erekle on 27.01.23.
//

import UIKit

class MainCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var quantity = 0
    var dict = [IndexPath: Int]()
    var index = IndexPath()
    
    var dict2 = [Int: Int]()
    
    var delegate: passData?
    
    @IBAction func plusButton(_sender: UIButton) {
        
        plus()
        delegate?.plusQuantity()
        delegate?.indexPlus(index: index, quantity: quantity)
        
    }
    @IBAction func minusButton(_sender: UIButton) {
        
        if quantity > 0{
            minus()
            delegate?.minusQuantity()
            delegate?.indexMinus(index: index, quantity: quantity)
        }
    }
    
    func plus() {
        quantity += 1
        //dict[index] = quanity
        
        self.quantityLabel.text = "\(quantity)"
    }
    
    func minus() {
        if quantity > 0 {
            quantity -= 1
            //dict[index] = quantity
            self.quantityLabel.text = "\(quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantity = 0
        self.stockLabel.text = "stock: "
        self.priceLabel.text = "price: "
        self.quantityLabel.text = ""
        self.quantityLabel.text = "\(quantity)"
        
    }
    
    override func prepareForReuse() {
        
        self.quantity = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

