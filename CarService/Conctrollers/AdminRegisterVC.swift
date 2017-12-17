//
//  AdminRegisterVC.swift
//  CarService
//
//  Created by Egor on 25.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class AdminRegisterVC: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passportTestField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var isAdminSwitch: UISwitch!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let picker = UIImagePickerController()

    
    @IBAction func continueButtonPressed(_ sender: Any) {
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
                somethingGoWrongAlert(message: "Please fill all gaps")
                return
        }
        
        if password.count < 6{
            somethingGoWrongAlert(message: "Password have to be at least 6 char.")
            return
        }
        
        let employee = Employee(image: image, name: name, surname: surname, position: position, adress: adress, phone: phone, passport: passport, isAdmin: isAdminSwitch.isOn, login: login, password: password)
        
        Employee.insert(employee)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        picker.delegate = self
        //setGesture() //какого то хера падает
        Employee.createTable()
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


extension AdminRegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
