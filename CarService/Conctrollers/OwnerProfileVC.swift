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
    let carCellNib = UINib(nibName: "CarCell", bundle: nil)
    var cars = [Car]()
    var isUpdate = false
    let picker = UIImagePickerController()

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
        nameTextField.isEnabled = !nameTextField.isEnabled
        surnameTextField.isEnabled = !surnameTextField.isEnabled
        driverLicenseTextField.isEnabled = !driverLicenseTextField.isEnabled
        phoneTextField.isEnabled = !phoneTextField.isEnabled
        passportTextField.isEnabled = !passportTextField.isEnabled
        passwordTextField.isHidden = !passwordTextField.isHidden
        
        nameTextField.isUserInteractionEnabled = !nameTextField.isUserInteractionEnabled
        surnameTextField.isUserInteractionEnabled = !surnameTextField.isUserInteractionEnabled
        driverLicenseTextField.isUserInteractionEnabled = !driverLicenseTextField.isUserInteractionEnabled
        phoneTextField.isUserInteractionEnabled = !phoneTextField.isUserInteractionEnabled
        passportTextField.isUserInteractionEnabled = !passportTextField.isUserInteractionEnabled
        passwordTextField.isUserInteractionEnabled = !passwordTextField.isUserInteractionEnabled
        profileImageView.isUserInteractionEnabled = !profileImageView.isUserInteractionEnabled
        
        if isUpdate{ //save
            if let editedOwner = checkGaps(){
                Owner.update(owner: editedOwner)
            }
        } 
        
        isUpdate = !isUpdate
        
    }
    
    private func checkGaps() -> Owner?{
        guard let imageData = profileImageView.image?.datatypeValue,
            let name = nameTextField.text, !name.isEmpty,
            let surname = surnameTextField.text, !surname.isEmpty,
            let license = Int(driverLicenseTextField.text!),
            let passport = passportTextField.text, !passport.isEmpty,
            let phone = phoneTextField.text, !phone.isEmpty,
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
        
        let owner = Owner(profileImage: imageData, name: name, surname: surname, driverLicense: license, passport: passport, phone: phone, login: login, password: password)
        
        return owner
    }
    
    @IBAction func addCarButtonPressed(_ sender: UIButton) {}
        
    @IBAction func logOutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func serviceButtonTaped(_ sender: Any) {}
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(carCellNib, forCellReuseIdentifier: carCellIdentifier)
        
        picker.delegate = self
        setGesture()
        fillTextFields()
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCars()
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
    
    private func fillTextFields(){
        //SELECT * FROM Owner WHERE login == ownerLogin LIMIT 1

        if let ownerLogin = login,
            let owner = Owner.selectForUserlogin(login: ownerLogin){
            
            nameTextField.text = owner.name
            surnameTextField.text = owner.surname
            driverLicenseTextField.text = String(owner.driverLicense)
            phoneTextField.text = owner.phone
            passportTextField.text = owner.passport
            loginTextField.text = owner.login
            passwordTextField.text = owner.password
            profileImageView.image = UIImage.fromDatatypeValue(owner.profileImage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let carVC = segue.destination as? CarVC{
            carVC.login = loginTextField.text
        }
        
        if let serviceVC = segue.destination as? ServiceVC{
            serviceVC.allCars = cars
        }
    }
    
    //MARK: Retrieve owner cars
    
    private func loadCars(){
        if let login = login{
            Car.retrieveCarsForOwner(login: login) { [weak self] cars in
                self?.cars = cars
                self?.tableView.reloadData()
            }
        }
    }

}

//MARK: - UITableVIewDelegate, UITableViewDataSource

extension OwnerProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: carCellIdentifier, for: indexPath) as! CarCell
        cell.carImageView.image = UIImage.fromDatatypeValue(cars[indexPath.row].image)
        cell.serialNumberLabel.text = "ID \(cars[indexPath.row].serialNumber)"
        cell.brandLabel.text = "Brand: \(cars[indexPath.row].brand)"
        cell.modelLabel.text = "Model: \(cars[indexPath.row].model)"
        cell.ownerLabel.text = "Owner: \(cars[indexPath.row].owner)"
        cell.colorLabel.text = "Color: \(cars[indexPath.row].color)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let car = cars[indexPath.row]
            
            Car.delete(bySerialNumber: car.serialNumber)
            cars.remove(at: indexPath.row)
            tableView.reloadData()
        }

    }
    
}

extension OwnerProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
