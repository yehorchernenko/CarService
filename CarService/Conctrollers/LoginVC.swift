//
//  LoginVC.swift
//  CarService
//
//  Created by Egor on 05.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import SQLite

class LoginVC: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {}

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            do{
                //SELECT login,password FROM Owner;
                for owner in try DataBase.shared.connection.prepare(Owner.table.select(Owner.loginExpression,Owner.passwordExpression)){
                    
                    if owner[Owner.loginExpression] == login && owner[Owner.passwordExpression] == password{
                        performSegue(withIdentifier: "ownerProfileSegue", sender: nil)
                    }
                }
            }catch{
                print("Throw error when login owner: \(error.localizedDescription)")
            }
        case 1:
            print("TODO")
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navC = segue.destination as? UINavigationController{
            if let ownerProfileVC = navC.childViewControllers.first as? OwnerProfileVC{
                ownerProfileVC.login = loginTextField.text
            }
        }
    }

}
