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
    @IBOutlet weak var datePickerFro : UIDatePicker!
    @IBOutlet weak var datePickerTo: UIDatePicker!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var orderBySwitch: UISwitch!
    @IBOutlet var searchByProccesView: UIView!
    @IBOutlet var searchByDateView: UIView!
    
    @IBOutlet weak var filteSwitch: UISwitch!
    //MARK: - Properties
    var services = [ExtendedService]()
    var dateToSearchFrom = Date()
    var dateToSearchTo = Date()

    var bachgroundView = UIView()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateFilterViewAndDateRepresenation()
        searchContainerView.addSubview(searchByProccesView)
        searchByProccesView.frame.size.width = UIScreen.main.bounds.width
        
        registerCell()
        fillTableView()
    }
    
    
    //MARK: - Methods
    private func setDateFilterViewAndDateRepresenation(){
        self.view.addSubview(bachgroundView)
        bachgroundView.frame = self.view.frame
        bachgroundView.backgroundColor = UIColor.black
        bachgroundView.alpha = 0.5
        bachgroundView.isHidden = true
        
        self.view.addSubview(searchByDateView)
        searchByDateView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 200)
        searchByDateView.center = view.center
        
    }
    
    private func fillTableView(){

        
        ExtendedService.selectAllEX { [weak self] retrivedServices in
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
            bachgroundView.isHidden = true

        case 5:
            searchByProccesView.isHidden = true
            searchByDateView.isHidden = false
            bachgroundView.isHidden = false
        default:
            searchByProccesView.isHidden = true
            searchByDateView.isHidden = true
            bachgroundView.isHidden = true
        }
        fillTableView()
    }
    @IBAction func orderBySwitchValueChanged(_ sender: UISwitch) {
        services.reverse()
        self.tableView.reloadData()
        
    }
    
    //process
    @IBAction func searchByPocessSwitchValueChanged(_ sender: UISwitch) {
        ExtendedService.selectEX(byProcessState: filteSwitch.isOn, services: { [weak self] retrivedServices in
                self?.services = retrivedServices
                self?.tableView.reloadData()
        })
    }
    
    //date
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == datePickerFro{
            dateToSearchFrom = sender.date
        }
        
        if sender == datePickerTo{
            dateToSearchTo = sender.date
        }
        
    }
    @IBAction func searchByDateButtonPressed(_ sender: UIButton) {
        
        self.searchByDateView.isHidden = true
        self.bachgroundView.isHidden = true
        filteSegmentedControl.selectedSegmentIndex = 0
        
        ExtendedService.selectEX(fromDate: dateToSearchFrom, to: dateToSearchTo) { [weak self] retrivedServices in
            self?.services = retrivedServices
            self?.tableView.reloadData()
        }

    }
        
        @IBAction func dismissDateView(_ sender: Any) {
        self.searchByDateView.isHidden = true
        self.bachgroundView.isHidden = true
        filteSegmentedControl.selectedSegmentIndex = 0
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
        cell.employeeLabel.text = "  Performer: \(services[indexPath.row].employeePosition) \(services[indexPath.row].employeeName) \(services[indexPath.row].employeeSurname) login(\(services[indexPath.row].employee))"
        cell.serviceTypeNameLabel.text = "Category of work: \(services[indexPath.row].typeName) \(services[indexPath.row].typeDescription) (id: \(services[indexPath.row].serviceType))"
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
                ExtendedService.selectEX(byId: id, services: { [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })

            case 1:
                guard let serailNumStr = searchBar.text, let serailNum = Int(serailNumStr) else {
                    somethingGoWrongAlert(message: "Use number for seearch by ID")
                    return
                }
                ExtendedService.selectEX(bySerialNumber: serailNum, services: {  [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            case 2:
                guard let serviceTypeStr = searchBar.text, let serviceTypeId = Int(serviceTypeStr) else {
                    somethingGoWrongAlert(message: "Use number for seearch by ID")
                    return
                }
                ExtendedService.selectEX(byServiceTypeId: serviceTypeId, services: { [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            case 3:
                guard let employeeLogin = searchBar.text else {
                    somethingGoWrongAlert(message: "Check your spell")
                    return
                }
                
                ExtendedService.selectEX(byEmployeeLogin: employeeLogin, services: { [weak self] retrivedServices in
                    self?.services = retrivedServices
                    self?.tableView.reloadData()
                })
            case 4:
                ExtendedService.selectEX(byProcessState: filteSwitch.isOn, services: { [weak self] retrivedServices in
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


