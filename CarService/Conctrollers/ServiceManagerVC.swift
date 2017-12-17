//
//  ServiceManagerVC.swift
//  CarService
//
//  Created by Egor on 17.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ServiceManagerVC: UIViewController {

    //MARK: - Oultes
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filteSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var orderBySwitch: UISwitch!
    
    @IBOutlet var searchByProccesView: UIView!
    @IBOutlet var searchByDateView: UIView!
    
    //MARK: - Properties
    var services = [Service]()
    var dateToSearch = Date()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchContainerView.addSubview(searchByDateView)
        searchByDateView.frame.size.width = UIScreen.main.bounds.width
        searchContainerView.addSubview(searchByProccesView)
        searchByProccesView.frame.size.width = UIScreen.main.bounds.width


        
        registerCell()
        fillTableView()
    }
    
    
    //MARK: - Methods
    private func fillTableView(){
        
        Service.selectAll { [weak self] retrivedServices in
            self?.services = retrivedServices
            self?.tableView.reloadData()
        }
        
    }
    
    private func registerCell(){
        let nib = UINib(nibName: "ServiceCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: serviceCellIdentifier)
    }
    
    @IBAction func filterSegmentedControllValureChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 4:
            searchByProccesView.isHidden = false
            searchByDateView.isHidden = true
        case 5:
            searchByProccesView.isHidden = true
            searchByDateView.isHidden = false
        default:
            searchByProccesView.isHidden = true
            searchByDateView.isHidden = true
        }
        fillTableView()
    }
    @IBAction func orderBySwitchValueChanged(_ sender: UISwitch) {
        services.reverse()
        self.tableView.reloadData()
        
    }
    
    //process
    @IBAction func searchByPocessSwitchValueChanged(_ sender: UISwitch) {
        Service.select(byProcessState: sender.isOn, services: {  [weak self] retrivedServices in
            self?.services = retrivedServices
            self?.tableView.reloadData()
        })
    }
    
    //date
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dateToSearch = sender.date
    }
    @IBAction func searchByDateButtonPressed(_ sender: UIButton) {
        Service.select(byDate: dateToSearch, services: {  [weak self] retrivedServices in
            self?.services = retrivedServices
            self?.tableView.reloadData()
        })
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension ServiceManagerVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: serviceCellIdentifier, for: indexPath) as! ServiceCell
        
        
        cell.idLabel.text = "\(services[indexPath.row].id!)"
        cell.employeeLabel.text = "Performer: \(services[indexPath.row].employee)"
        cell.serviceTypeNameLabel.text = "Category of work: \(services[indexPath.row].serviceType)"
        cell.onProccesSwitch.isOn = services[indexPath.row].onProcess
        cell.incomeDateLabel.text = "Income date: \(incomeDate(services[indexPath.row].date))"
        cell.descriptionTextView.text = "Car serial number: \(services[indexPath.row].car)"
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


//MARK: - UISearchBarDelegate

extension ServiceManagerVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == nil || searchBar.text == "" || searchBar.text == " " {
            somethingGoWrongAlert(message: "Please enter your predicate")
        } else {
            
            switch filteSegmentedControl.selectedSegmentIndex {
            case 0:
                guard let idStr = searchBar.text, let id = Int(idStr) else {
                    somethingGoWrongAlert(message: "Use number for seearch by ID")
                    return
                }
                Service.select(byId: id, services: {  [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            case 1:
                guard let serailNumStr = searchBar.text, let serailNum = Int(serailNumStr) else {
                    somethingGoWrongAlert(message: "Use number for seearch by ID")
                    return
                }
                Service.select(bySerialNumber: serailNum, services: {  [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            case 2:
                guard let serviceTypeStr = searchBar.text, let serviceTypeId = Int(serviceTypeStr) else {
                    somethingGoWrongAlert(message: "Use number for seearch by ID")
                    return
                }
                Service.select(byServiceTypeId: serviceTypeId, services: {  [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            case 3:
                guard let employeeLogin = searchBar.text else {
                    somethingGoWrongAlert(message: "Check your spell")
                    return
                }
                Service.select(byEmployeeLogin: employeeLogin, services: {  [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            default:
                fillTableView()
            }
            
            self.view.endEditing(true)
        }

    }
}


