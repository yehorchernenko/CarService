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
    var allCars = [Car]() //get cars from owner vc
    var allEmployees = [Employee]()
    var allSeriveTypes = [ServiceType]()
    var services = [ExtendedService]()
    
    var currentCar: Car?
    var currentEmployee: Employee?
    var currentServiceType: ServiceType?
    
    //can be nil because we will reuse this VC for admin
    var isOwnerServices = true
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.createTable()
        
        //delgate
        carPicker.delegate = self
        serviceTypePicker.delegate = self
        employeePicker.delegate = self
                
        fillPickersDataSource()
        
        fillTableView()
        
        registerCell()
        
        setupCurrentDate()
    }
    
    //MARK: - Methods
    
    private func fillTableView(){
        
        if isOwnerServices {
            ExtendedService.selectEX(forUserCars: allCars, services: { [weak self] retrivedServices in
                self?.services = retrivedServices
                self?.tableView.reloadData()
            })

        }
        else {
            ExtendedService.selectAllEX({ [weak self] retrivedServices in
                self?.services = retrivedServices
                self?.tableView.reloadData()
            })
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
        
        let newService = Service(id: nil, car: carSerialNum, serviceType: serviceTypeId, employee: employeeLogin, onProcess: true)
        
        Service.insert(newService)
        
        fillTableView()
    }
    
    private func fillPickersDataSource(){
        Employee.selectAll { [weak self] employees in
            self?.allEmployees = employees
            self?.employeePicker.reloadAllComponents()
        }
        
        ServiceType.selectAll { [weak self] servicTypes in
            self?.allSeriveTypes = servicTypes
            self?.serviceTypePicker.reloadAllComponents()
        }
        
        if !isOwnerServices{
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
        
        
        cell.idLabel.text = "\(services[indexPath.row].id!)"
        cell.employeeLabel.text = "  Performer: \(services[indexPath.row].employeePosition) (\(services[indexPath.row].employeeName) \(services[indexPath.row].employeeSurname))"
        cell.serviceTypeNameLabel.text = "Category of work: \(services[indexPath.row].typeName) \(services[indexPath.row].typeDescription) (id: \(services[indexPath.row].serviceType)"
        cell.onProccesSwitch.isOn = services[indexPath.row].onProcess
        cell.incomeDateLabel.text = "Income date: \(incomeDate(services[indexPath.row].date))"
        cell.descriptionTextView.text = """
        Car serial number: \(services[indexPath.row].car)
        Model: \(services[indexPath.row].carBrand) \(services[indexPath.row].carModel)
        color: \(services[indexPath.row].carColor)
        Owner: \(services[indexPath.row].ownerName) \(services[indexPath.row].ownerSurname)
        """
        cell.priceLabel.text = "Price: \(services[indexPath.row].typePrice) USD"
        cell.onProccesSwitch.isOn = services[indexPath.row].onProcess
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            guard let serviceId = services[indexPath.row].id else {return}
            
            Service.delete(byCarSerialNumber: nil, serviceType: nil, selfId: serviceId)
            services.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
   //additonal mehod
    private func incomeDate(_ date: Date) -> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        
        return dateFormater.string(from: date)
    }
    
}
