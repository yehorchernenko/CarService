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
        else {
            somethingGoWrongAlert(message: "Please fill all fields")
            return
        }
        
        let newOwner = Owner(profileImage: imageData, name: name, surname: surname, driverLicense: license, passport: passport, phone: phone, login: login, password: password)

        let insert = Owner.insert(profileImage: newOwner.profileImage, name: newOwner.name, surname: newOwner.surname, driverLicense: newOwner.driverLicense, passport: newOwner.passport, phone: newOwner.phone, login: newOwner.login, password: newOwner.password)
        
        do{
            try DataBase.shared.connection.run(insert)
            print("New data were inserted")
            
            dismiss(animated: true, completion: nil)
        } catch {
            print("DataBase inserting error: \(error.localizedDescription)")
        }

    }
    
    //MARK: Properties
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        do{
            try DataBase.shared.connection.run(Owner.createTable())
        } catch {
            print("Can't create Owner table")
        }
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
        setGesture()
        picker.delegate = self
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

    private func setGesture(){
        let imageViewGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        profileImage.addGestureRecognizer(imageViewGesture)
    }
    
    @objc private func showImagePicker(recognizer: UIGestureRecognizer){
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
}

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

