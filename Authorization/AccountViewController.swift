//
//  AccountViewController.swift
//  Authorization
//
//  Created by Roman Efimov on 20/11/2019.
//  Copyright © 2019 Roman Efimov. All rights reserved.
//

import UIKit
import Locksmith

class AccountViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        greetingLabel.text = "Здравствуйте, " + username + "!"
    }
    
    @IBAction func deleteAccounut(_ sender: Any) {
        let alert = UIAlertController(title: "Вниманиие", message:"Вы действительно хотите удалить аккаунт?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            do{
                try Locksmith.deleteDataForUserAccount(userAccount: "User")
                self.navigationController?.popViewController(animated: true)
            } catch {
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func exitButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
