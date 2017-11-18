//
//  OwnerProfileVC.swift
//  CarService
//
//  Created by Egor on 05.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import SQLite

class OwnerProfileVC: UIViewController {
    
    //MARK: - Properties
    var login: String?
    var dataBase: Connection!
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var driverLicenseTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passportTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addCarButtonPressed(_ sender: UIButton) {
        let addView = AddCarPopUpView(login: "asd")
        addView.show(animated: true)
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
        
        fillTextFields()
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    }
    
    private func fillTextFields(){
        if let ownerLogin = login{
            //SELECT * FROM Owner WHERE login == ownerLogin LIMIT 1
            let ownerTable = Owner.table.where(Owner.loginExpression == ownerLogin).limit(1)
            
            do{
                let owner = try dataBase.pluck(ownerTable)
                
                nameTextField.text = owner?[Owner.loginExpression]
                surnameTextField.text = owner?[Owner.surnameExpression]
                driverLicenseTextField.text = String(describing: owner?[Owner.driverLicenseExpression])
                phoneTextField.text = owner?[Owner.phoneExpression]
                loginTextField.text = owner?[Owner.loginExpression]
                passwordTextField.text = owner?[Owner.passwordExpression]
                passportTextField.text = owner?[Owner.passportExpression]
                
                if let imageBlob = owner?[Owner.profileImageExpression]{
                profileImageView.image = UIImage.fromDatatypeValue(imageBlob)
                }
                
                
                
            } catch {
                print("Error during filling profile text fieds: \(error.localizedDescription)")
            }
        }
    }
}

extension OwnerProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
