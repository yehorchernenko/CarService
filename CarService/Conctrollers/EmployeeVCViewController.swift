//
//  EmployeeVCViewController.swift
//  CarService
//
//  Created by Egor on 26.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class EmployeeVC: UIViewController{
    
    //MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logineTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var passportTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
