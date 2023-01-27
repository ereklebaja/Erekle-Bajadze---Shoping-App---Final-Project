//
//  ViewController2.swift
//  Erekle Bajadze - Shoping App - Final Project
//
//  Created by Erekle on 27.01.23.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var mainQuantityLabel: UILabel!
    @IBOutlet weak var mainTotalLabel: UILabel!
    
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController3") as? ViewController3
        
            vc?.imageDict = self.imageDict
            vc?.newDict = self.dict4
        
        for i in self.filteredArray3{
            if dict4.contains(where: {$0.key == i.id}){
                self.filteredArray4.append(i)
            }
        }
        
        vc?.array = self.filteredArray4
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    // ----ცვლადი მონაცემები---- //
    
    var array = [ProductModel]()
    var filteredArray = [ [productsArray] ]()
    var filteredArray2 = [productsArray: IndexPath]()
    var filteredArray3 = [productsArray]()
    var filteredArray4 = [productsArray]()
    var imageDict = [String: UIImage]()
    var mainQuantity = 0 // საწყისი განულება რაიოენობის
    var mainTotal = 0    // საწყისი განულება ჯამური თანხის
    var dict4 = [Int: Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainQuantityLabel.text = "\(mainQuantity)" // მინიჭება საწყისი რაოდენობის 0
        self.mainTotalLabel.text = "\(mainTotal)"       // მინიჭება საწყისი ჯამური თანხის 0
        self.table.delegate = self
        self.table.dataSource = self
        let nib = UINib(nibName: "MainCell", bundle: nil)
        self.table.register(nib, forCellReuseIdentifier: "MainCell")
        
        ProductManager.shared.getProductData(urlString: "https://dummyjson.com/products")
        NetworkManager.shared.getData(string: "https://dummyjson.com/products") { (data: ProductModel?, error) in
            
            if let error {
                print(error)
                return
            }
            
            guard let data else {
                return
            }
            
            DispatchQueue.main.async {
                self.array.append(data)
                self.table.reloadData()
                
                for i in (self.array.first?.products)! {
                
                    if self.filteredArray.contains(where: {$0.contains(where: {$0.category == i.category})}) {
                        
                    } else {
                        
                        self.filteredArray.append((self.array.first?.products.filter {$0.category == i.category})!)
                        
                    }
                }
                
                for i in 0...(self.array.first?.products.count)!-1 {
                    
                    self.downloadImage(url: (self.array.first?.products[i].images.first)!)
                    
                }
            }
        }
    }
    
    func downloadImage(url: String) {
        
        guard let newUrl = URL(string: url) else {return}
        let session = URLSession(configuration: .default)

        let downloadPicture = session.dataTask(with: newUrl) { (data, response, error) in
            
            if let error {
                print(error)
            } else {
                
                if let response = response as? HTTPURLResponse {
                    
                    if let imageData = data {
                        
                        DispatchQueue.main.async {
                            self.imageDict[url] = UIImage(data: imageData)!
                            self.table.reloadData()
                        }
                    } else {
                        print("Can't Show Image: Image is Empty")
                    }
                } else {
                    print("Problem To Get Response")
                }
            }
        }.resume()
    }
}

extension ViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.filteredArray[section].first?.category
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.filteredArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredArray[section].count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.delegate = self
        cell.index = indexPath
        cell.brandLabel.text = self.filteredArray[indexPath.section][indexPath.row].brand
        cell.stockLabel.text = "stock : \((self.filteredArray[indexPath.section][indexPath.row].stock))"
        cell.priceLabel.text = "price: \((self.filteredArray[indexPath.section][indexPath.row].price))"
        
        cell.quantityLabel.text = "\(self.dict4[self.filteredArray[indexPath.section][indexPath.row].id] ?? 0)"
        
        cell.productImage.image = self.imageDict[self.filteredArray[indexPath.section][indexPath.row].images.first ?? "Error"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139.0
    }
    
    
}

extension ViewController2: passData{
    
    
    func indexPlus(index: IndexPath, quantity: Int) {
        
        self.filteredArray3.append(filteredArray[index.section][index.row])
        self.filteredArray2[filteredArray[index.section][index.row]] = index
        self.mainTotal += self.filteredArray[index.section][index.row].price
        self.mainTotalLabel.text = "\(self.mainTotal)"
        
        self.dict4[filteredArray[index.section][index.row].id] = quantity
        
        self.dict4 = self.dict4.filter{$0.value > 0}
        
    }
    
    func indexMinus(index: IndexPath, quantity: Int) {
        self.mainTotal -= self.filteredArray[index.section][index.row].price
        self.mainTotalLabel.text = "\(self.mainTotal)"
        self.dict4[filteredArray[index.section][index.row].id] = quantity
        
        self.dict4 = self.dict4.filter{$0.value > 0}
    }
    
    func plusQuantity() {
        self.mainQuantity += 1
        self.mainQuantityLabel.text = "\(mainQuantity)"
        
    }
    
    func minusQuantity() {
        if self.mainQuantity > 0 {
            self.mainQuantity -= 1
            self.mainQuantityLabel.text = "\(mainQuantity)"
        }
    }
}

protocol passData {
    func plusQuantity()
    func minusQuantity()
    func indexPlus(index: IndexPath, quantity: Int)
    func indexMinus(index: IndexPath, quantity: Int)
}

