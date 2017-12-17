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
    var isUpdate = false
    let picker = UIImagePickerController()
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        nameTextField.isEnabled = !nameTextField.isEnabled
        surnameTextField.isEnabled = !surnameTextField.isEnabled
        positionTextField.isEnabled = !positionTextField.isEnabled
        phoneTextField.isEnabled = !phoneTextField.isEnabled
        adressTextField.isEnabled = !adressTextField.isEnabled
        passportTestField.isEnabled = !passportTestField.isEnabled
        passwordTextField.isHidden = !passwordTextField.isHidden
        
        nameTextField.isUserInteractionEnabled = !nameTextField.isUserInteractionEnabled
        surnameTextField.isUserInteractionEnabled = !surnameTextField.isUserInteractionEnabled
        positionTextField.isUserInteractionEnabled = !positionTextField.isUserInteractionEnabled
        phoneTextField.isUserInteractionEnabled = !phoneTextField.isUserInteractionEnabled
        passportTestField.isUserInteractionEnabled = !passportTestField.isUserInteractionEnabled
        passwordTextField.isUserInteractionEnabled = !passwordTextField.isUserInteractionEnabled
        adressTextField.isUserInteractionEnabled = !adressTextField.isUserInteractionEnabled
        profileImageView.isUserInteractionEnabled = !profileImageView.isUserInteractionEnabled
        
        if isUpdate{ //save
            if let editedEmployee = checkGaps(){
                Employee.update(employee: editedEmployee)
            }
        }
        
        isUpdate = !isUpdate
        
    }
    
    private func checkGaps() -> Employee?{
        guard let image = profileImageView.image?.datatypeValue,
            let surname = surnameTextField.text, !surname.isEmpty,
            let name = nameTextField.text, !name.isEmpty,
            let phone = phoneTextField.text, !phone.isEmpty,
            let passport = passportTestField.text, !passport.isEmpty,
            let position = positionTextField.text, !position.isEmpty,
            let adress = adressTextField.text, !adress.isEmpty,
            let login = loginTextField.text, !login.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                somethingGoWrongAlert(message: "Please fill all fields")
                return nil
        }
        
        if password.count < 6{
            somethingGoWrongAlert(message: "Password have to be at least 6 char.")
            return nil
        }
        
        let employee = Employee(image: image, name: name, surname: surname, position: position, adress: adress, phone: phone, passport: passport, isAdmin: false, login: login, password: password)
        
        return employee
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        setGesture()
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
    
    private func setGesture(){
        let imageViewGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        profileImageView.addGestureRecognizer(imageViewGesture)
    }
    
    @objc private func showImagePicker(recognizer: UIGestureRecognizer){
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
}

extension EmployeeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

