//
//  RegisterVC.swift
//  CarService
//
//  Created by Egor on 22.10.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import SQLite

class RegisterVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UITextField!
    @IBOutlet weak var surnameLbl: UITextField!
    @IBOutlet weak var driverLicenceLbl: UITextField!
    @IBOutlet weak var passportLbl: UITextField!
    @IBOutlet weak var phoneLbl: UITextField!
    @IBOutlet weak var loginLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        guard let imageData = profileImage.image?.datatypeValue,
            let name = nameLbl.text,
            let surname = surnameLbl.text,
            let license = Int(driverLicenceLbl.text!),
            let passport = passportLbl.text,
            let phone = phoneLbl.text,
            let login = loginLbl.text,
            let password = passwordLbl.text
        else {return}
        
        let newOwner = Owner(profileImage: imageData, name: name, surname: surname, driverLicense: license, passport: passport, phone: phone, login: login, password: password)
        
        let insert = self.ownerTable.insert(self.loginExpression <- newOwner.login,
                                            self.passwordExpression <- newOwner.password,
                                            self.profileImageExpression <- newOwner.profileImage,
                                            self.nameExpression <- newOwner.name,
                                            self.surnameExpression <- newOwner.surname,
                                            self.driverLicenseExpression <- newOwner.driverLicense,
                                            self.passportExpression <- newOwner.passport,
                                            self.phoneExpression <- newOwner.phone)
        
        do{
            try dataBase.run(insert)
            
            print("New data had inserted")
        } catch {
            print("DataBase inserting error: \(error.localizedDescription)")
        }
        //let insert = self.usersTable.insert(self.name <- name, self.email <- email)

    }
    
    //MARK: Properties
    var dataBase: Connection!
    
    fileprivate var ownerTable: Table = Table("Owner")
    
    fileprivate let profileImageExpression = Expression<Blob>("profileImage")
    fileprivate let nameExpression = Expression<String>("name")
    fileprivate let surnameExpression = Expression<String>("surname")
    fileprivate let driverLicenseExpression = Expression<Int>("driverLicense")
    fileprivate let passportExpression = Expression<String>("passport")
    fileprivate let phoneExpression = Expression<String>("phone")
    fileprivate let loginExpression = Expression<String>("login") //primary key
    fileprivate let passwordExpression = Expression<String>("password")
    
    func createTable() -> String{
        let createTable = self.ownerTable.create { [unowned self] table in
            table.column(self.loginExpression, primaryKey: true)
            table.column(self.passwordExpression)
            table.column(self.profileImageExpression)
            table.column(self.nameExpression)
            table.column(self.surnameExpression)
            table.column(self.driverLicenseExpression)
            table.column(self.passportExpression)
            table.column(self.phoneExpression)
        }
        return createTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        do{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            dataBase = try Connection("\(path)/db.sqlite3")
            
            try self.dataBase.run(createTable())
            
            print("Succesful connection to data base")
        } catch{
            print("DataBase conection error: \(error.localizedDescription)")
        }
        
        
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    }
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyBoardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.continueButtonBottomConstraint.constant == 0{
                self.continueButtonBottomConstraint.constant += keyBoardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil{
            if self.continueButtonBottomConstraint.constant != 0{
                self.continueButtonBottomConstraint.constant = 0
            }
        }
    }

}

