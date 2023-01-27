//
//  ViewController.swift
//  Erekle Bajadze - Shoping App - Final Project
//
//  Created by Erekle on 27.01.23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    
    }
    
    func initialSetup() {
        
        self.emailTF.delegate = self
        self.emailTF.layer.masksToBounds = true
        self.emailTF.layer.cornerRadius = 14
        self.emailTF.textContentType = .emailAddress
        self.emailTF.keyboardType = .emailAddress
        self.emailTF.returnKeyType = .done
        self.emailTF.accessibilityLabel = "Registration"
        self.emailTF.layer.borderWidth = 0.5
        self.emailTF.clearButtonMode = .always
        
        self.passwordTF.delegate = self
        self.passwordTF.isSecureTextEntry = true //პაროლის დაფარვა (არ გამოჩენა)
        self.passwordTF.layer.masksToBounds = true
        self.passwordTF.layer.cornerRadius = 14
        self.passwordTF.textContentType = .password
        self.passwordTF.layer.borderWidth = 0.5
        self.passwordTF.clearButtonMode = .always
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "იტვირთება...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
            
            if emailTF.text?.isValidEmail() == true {
                
                if passwordTF.text != ""  && passwordTF.text?.isValidPassword() == true {
                    
                    showAlert()
                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                        
                        self.dismiss(animated: true)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "ViewController2") as! ViewController2
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    passwordTF.layer.borderWidth = 2
                    passwordTF.layer.borderColor = UIColor.red.cgColor
                    passwordTF.shake()
                }
                
            } else {
                
                emailTF.layer.borderWidth = 2
                emailTF.layer.borderColor = UIColor.red.cgColor
                emailTF.shake()
                
                if passwordTF.text == "" {
                    passwordTF.layer.borderWidth = 2
                    passwordTF.layer.borderColor = UIColor.red.cgColor
                    passwordTF.shake()
                }
            }
    }
    
    
}

extension String {
    //მაილის ვალიდაცია @.
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,3})$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Email validation \(valid)")
        return valid
    }
    //პაროლის ვალიდაცია მინიმუმ 6 სიმბოლო = მინ 1 ციფრი და ასოები
    func isValidPassword() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Pasword validation \(valid)")
        return valid
    }
    
}

extension UIView {
    func shake() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -10, 10, 0]
        //animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        
        animation.isAdditive = true
        layer.add(animation, forKey: "shake")
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        emailTF.layer.borderColor = .none
        emailTF.layer.borderWidth = 0.5
        passwordTF.layer.borderColor = .none
        passwordTF.layer.borderWidth = 0.5
    }
}
