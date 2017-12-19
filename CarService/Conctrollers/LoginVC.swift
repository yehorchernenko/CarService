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
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            signUpButton.setTitle("Sign up as user", for: .normal)
        case 1:
            signUpButton.setTitle("Sign up as employer", for: .normal)
        default:
            signUpButton.setTitle("Sign up", for: .normal)
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let login = loginTextField.text, !login.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                somethingGoWrongAlert(message: "Fill all gaps.")
                return
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: // user
            
            //SELECT login,password FROM Owner;
            if Owner.login(login, password: password){
                performSegue(withIdentifier: "ownerProfileSegue", sender: nil)
            } else {
                somethingGoWrongAlert(message: "Incorect password or login")
            }
            
        case 1: //admin
    
            //TODO: - Extract method this scope
            let sb = UIStoryboard(name: "Employee", bundle: nil)
            
            guard let status = Employee.login(login, password: password)
                else{
                    somethingGoWrongAlert(message: "Incorect password or login")
                    return
            }
            
            if status{
                let navVC = sb.instantiateViewController(withIdentifier: "adminVCidentifier")
                if let adminVC = navVC.childViewControllers.first as? AdminVC{
                    adminVC.login = login
                    
                    present(navVC, animated: true, completion: nil)
                }
            } else {
                let navVC = sb.instantiateViewController(withIdentifier: "employeeVCidentifier")
                if let employeeVC = navVC.childViewControllers.first as? EmployeeVC{
                    employeeVC.login = login
                    
                    present(navVC, animated: true, completion: nil)
                }
            }
            
        default:
            return
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: signUpAsUserSegue, sender: nil)
        case 1:
            performSegue(withIdentifier: signUpAsEmployerSegue, sender: nil)
        default:
            somethingGoWrongAlert(message: "Can't performSegue")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            try DataBase.shared.connection.execute("PRAGMA foreign_keys = ON;")
        } catch {
            print("foreign key error")
        }

        
       print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navC = segue.destination as? UINavigationController{
            if let ownerProfileVC = navC.childViewControllers.first as? OwnerProfileVC{
                ownerProfileVC.login = loginTextField.text
            }
        }
    }

}
