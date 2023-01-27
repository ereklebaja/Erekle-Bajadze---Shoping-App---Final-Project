//
//  ViewController3.swift
//  Erekle Bajadze - Shoping App - Final Project
//
//  Created by Erekle on 27.01.23.
//

import UIKit

class ViewController3: UIViewController {
    
    @IBOutlet weak var table3: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var totalPriceNumber: UILabel!
    @IBOutlet weak var feeNumber: UILabel!
    @IBOutlet weak var deliveryNumber: UILabel!
    @IBOutlet weak var totalNumber: UILabel!
    
    var totals = [IndexPath: Int]()
    
    var array = [productsArray]()
    var imageDict = [String: UIImage]()
    
    var filteredArray = [productsArray]()
    
    var newDict = [Int: Int]()
    var newTotalArray = [Int]()
    var newTotalNumber = 0
    
    @IBAction func nextButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as? SuccessVC
        
        self.present(vc!, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in array {
            if filteredArray.contains(where: {$0.id == i.id}) {
                
            }
            else {
                filteredArray.append(i)
            }
        }
        
        totalPrice.text = "total price"
        fee.text = "fee"
        delivery.text = "delivery"
        total.text = "TOTAL:"
        
        feeNumber.text = "\(50)"
        deliveryNumber.text = "Free"
        
        updateValue()
        
        self.table3.dataSource = self
        self.table3.delegate = self
        let nib = UINib(nibName: "SecondaryCell", bundle: nil)
        self.table3.register(nib, forCellReuseIdentifier: "SecondaryCell")
    }
    
    func updateValue() {
        self.totalNumber.text = String((Int(self.feeNumber.text ?? "") ?? 0) + (Int(self.deliveryNumber.text ?? "") ?? Int(0)) + self.newTotalNumber)
    }
    
}

extension ViewController3: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table3.dequeueReusableCell(withIdentifier: "SecondaryCell", for: indexPath) as! SecondaryCell
        
        
        cell.delegate = self
        cell.brandNameVC3.text = filteredArray[indexPath.row].brand
        cell.imageVC3.image = self.imageDict[self.filteredArray[indexPath.row].images.first ?? "Error"]
        cell.quantityVC3.text = "\(self.newDict[filteredArray[indexPath.row].id] ?? 0)"
        cell.subtotalVC3.text = "\(filteredArray[indexPath.row].price * (self.newDict[filteredArray[indexPath.row].id] ?? 0))"
        
        cell.total[indexPath] = Int("\(filteredArray[indexPath.row].price * (self.newDict[filteredArray[indexPath.row].id] ?? 0))") ?? 0
        
        cell.delegate?.passData(dict: cell.total)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

protocol Passer {
    func passData(dict: [IndexPath: Int])
}

extension ViewController3: Passer {
    func passData(dict: [IndexPath : Int]) {
        
        self.totals = dict
        
        for i in self.totals {
            self.newTotalArray.append(i.value)
        }
        
        let withoutDuplicates = Array(Set(self.newTotalArray))
        self.newTotalNumber = withoutDuplicates.reduce(0, +)
        self.totalPriceNumber.text = "\(self.newTotalNumber)"
        
        self.updateValue()
    }
}


