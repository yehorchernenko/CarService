//
//  EmployeeVC.swift
//  CarService
//
//  Created by Egor on 27.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class EmployeeVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passportTestField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Properties
    var login: String?
    

    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTextFields()
    }

    private func fillTextFields(){
        //SELECT * FROM Employee WHERE login == ownerLogin LIMIT 1
        
        if let employeeLogin = login,
            let employee = Employee.selectEmployeeFromLogin(login: employeeLogin){
            
            profileImageView.image = UIImage.fromDatatypeValue(employee.image)
            surnameTextField.text = employee.surname
            nameTextField.text = employee.name
            positionTextField.text = employee.position
            adressTextField.text = employee.adress
            phoneTextField.text = employee.phone
            passportTestField.text = employee.passport
            loginTextField.text = employee.login
            passwordTextField.text = employee.password
            

        }
    }
}
