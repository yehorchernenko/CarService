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
    var dataBase: Connection!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            do{
                for owner in try dataBase.prepare(Owner.ownerTable.select(Owner.loginExpression,Owner.passwordExpression)){
                    if owner[Owner.loginExpression] == login && owner[Owner.passwordExpression] == password{
                        print("Catched")
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
        
        do{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            dataBase = try Connection("\(path)/db.sqlite3")
            
            
            print("Succesful connection to data base")
        } catch{
            print("DataBase conection error: \(error.localizedDescription)")
        }
        
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    }

}