//
//  ViewController.swift
//  Authorization
//
//  Created by Roman Efimov on 20/11/2019.
//  Copyright © 2019 Roman Efimov. All rights reserved.
//

import UIKit
import Locksmith
import LocalAuthentication



class ViewController: UIViewController {
    
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var idIcon: UIImageView!
    
    var alertText: String = ""
    var username: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginField.delegate = self
        self.passwordField.delegate = self
        
        registrationButton.layer.cornerRadius = 15
        biometricType()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.cellTappedMethod(_:)))
        idIcon.addGestureRecognizer(tapGestureRecognizer)
        idIcon.isUserInteractionEnabled = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkReg()
    }


    @IBAction func registrationButton(_ sender: Any) {
        if loginField.text != "" && passwordField.text != "" {
            if let login = loginField.text , let password = passwordField.text{
                do {
                    try Locksmith.saveData(data: ["login" : login, "password" : password], forUserAccount: "User")
                    loginField.text = ""
                    passwordField.text = ""
                    let alert = UIAlertController(title: "Вы успешно зарегистрировались", message:"Войдите в аккаунт используя TouchID или FaceID", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) in
                        self.checkReg()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } catch {
                   let alert = UIAlertController(title: "Вы уже зарегистрированны", message:"Войдите в аккаунт используя TouchID или FaceID", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Повторить", style: UIAlertAction.Style.cancel, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Ошибка  регистрации", message:"Заполните поля логина и пароля. Они не могут быть пустыми.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Повторить", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func logIn(){
        let dict = Locksmith.loadDataForUserAccount(userAccount: "User")
        if dict == nil {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка входа", message:"Сначала зарегистрируйтесь, а потом повторите попытку", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            username = dict!["login"] as! String
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "show", sender: nil)
            }
        }
    }
    
    
    func checkReg(){
        let dict = Locksmith.loadDataForUserAccount(userAccount: "User")
        print (dict)
        if dict != nil {
            loginField.isHidden = true
            passwordField.isHidden = true
            registrationButton.isHidden = true
            idIcon.isHidden = false
        } else {
            loginField.isHidden = false
            passwordField.isHidden = false
            registrationButton.isHidden = false
            idIcon.isHidden = true
        }
        
    }
    
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        print ("Tap")
        
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: alertText) { (wasSuccessfull, error) in
                if wasSuccessfull{
                    print ("OK")
                    self.logIn()
                } else {
                    print ("Please, try again")
                }
            }
        } 
    }
    
  
    
    
    func biometricType() {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                print ("Error biometrics")
            case .touchID:
                print ("Touch ID")
                idIcon.image = #imageLiteral(resourceName: "print")
                alertText = "Приложите палец, чтобы войти в приложение"
            case .faceID:
                print ("Face ID")
                idIcon.image = #imageLiteral(resourceName: "faceid")
                alertText = "Посмотрите в камеру, чтобы войти в приложение"
            }
        } else {
             print ("Error biometrics, iOS version is older")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let  destinationVC = segue.destination as? AccountViewController
            destinationVC?.username = username
        }
    }
    
}


extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

