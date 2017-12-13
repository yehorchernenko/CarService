//
//  ServiceVC.swift
//  CarService
//
//  Created by Egor on 05.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ServiceVC: UIViewController {

    @IBOutlet weak var carPicker: UIPickerView!
    @IBOutlet weak var serviceTypePicker: UIPickerView!
    @IBOutlet weak var employeePicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var allCars = [Car]()
    var allEmployees = [Employee]()
    var allSeriveTypes = [ServiceType]()
    var services = [Service]()
    
    var currentCar: Car?
    var currentEmployee: Employee?
    var currentServiceType: ServiceType?
    
    //can be nil because we will reuse this VC for admin
    var ownerLogin: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.createTable()
        
        //delgate
        carPicker.delegate = self
        serviceTypePicker.delegate = self
        employeePicker.delegate = self
                
        fillPickersDataSource(login: self.ownerLogin)
        
        fillTableView()
        
        registerCell()
        
        setupCurrentDate()
    }
    
    //MARK: - Methods
    
    private func fillTableView(){
        
        if let login = ownerLogin{
            Service.select(forUserLogin: login)  { [weak self] retrivedServices in
                self?.services = retrivedServices
                self?.tableView.reloadData()
            }
        }
        else {
            Service.selectAll { [weak self] retrivedServices in
                self?.services = retrivedServices
                self?.tableView.reloadData()
            }
        }
    }
    
    private func registerCell(){
        let nib = UINib(nibName: "ServiceCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: serviceCellIdentifier)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let carSerialNum = currentCar?.serialNumber,
            let employeeLogin = currentEmployee?.login,
            let serviceTypeId = currentServiceType?.id
            else{ somethingGoWrongAlert(message: "Please select row in picker"); return}
        
        let newService = Service(id: nil, car: carSerialNum, serviceType: serviceTypeId, employee: employeeLogin)
        
        Service.insert(newService)
        
        fillTableView()
    }
    
    private func fillPickersDataSource(login: String?){
        Employee.selectAll { [weak self] employees in
            self?.allEmployees = employees
            self?.employeePicker.reloadAllComponents()
        }
        
        ServiceType.selectAll { [weak self] servicTypes in
            self?.allSeriveTypes = servicTypes
            self?.serviceTypePicker.reloadAllComponents()
        }
        
        if let ownerLogin = login{
            Car.retrieveCarsForOwner(login: ownerLogin, cars: { [weak self] allUserCars in
                self?.allCars = allUserCars
                self?.carPicker.reloadAllComponents()
            })
        } else {
            Car.selectAll(cars: { [weak self] cars in
                self?.allCars = cars
                self?.carPicker.reloadAllComponents()
            })
        }
        
    }
    
    
    private func setupCurrentDate(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        
        let now = dateFormater.string(from: Date())
        self.dateLabel.text = now
    }
    

}


//MARK: - PickerViewDelegate

extension ServiceVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == carPicker{
            return allCars.count
        } else if pickerView == serviceTypePicker{
            return allSeriveTypes.count
        } else if pickerView == employeePicker{
            return allEmployees.count
        } else {
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == carPicker{
            return allCars[row].model + " " + allCars[row].brand
        } else if pickerView == serviceTypePicker{
            return allSeriveTypes[row].name
        } else if pickerView == employeePicker{
            return allEmployees[row].name + " " + allEmployees[row].surname
        } else {
            return nil
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == carPicker{
            currentCar = allCars[row]
        } else if pickerView == serviceTypePicker{
            currentServiceType = allSeriveTypes[row]
        } else if pickerView == employeePicker{
            currentEmployee = allEmployees[row]
        }
    }
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ServiceVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: serviceCellIdentifier, for: indexPath) as! ServiceCell
        
        cell.idLabel.text = "ID: \(services[indexPath.row].id!)"
        cell.employeeLabel.text = "Performer: \(services[indexPath.row].employee)"
        cell.serviceTypeNameLabel.text = "Category of work: \(services[indexPath.row].serviceType)"
        cell.incomeDateLabel.text = "Income date: \(incomeDate(services[indexPath.row].date))"
        
        return cell
    }
    
    private func incomeDate(_ date: Date) -> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        
        return dateFormater.string(from: date)
    }
}
