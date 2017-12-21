//
//  ServiceCell.swift
//  CarService
//
//  Created by Egor on 10.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    @IBOutlet weak var serviceTypeNameLabel: UILabel!
    
    @IBOutlet weak var onProccesSwitch: UISwitch!
    @IBOutlet weak var incomeDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var service: ExtendedService?
    var delegate: IMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.masksToBounds = true
    }
    
    @IBAction func onProccesSwitchValueChanged(_ sender: UISwitch) {
        guard let id = service?.id, let login = service?.ownerLogin else {return}
        Service.updateProcess(state: sender.isOn, byId: id)
        
        guard let currentOwner = Owner.selectForUserlogin(login: login) else {return}
        
        let text = "Dear \(currentOwner.name) \(currentOwner.surname) your order #\(id) change process status to:  \(sender.isOn ? "In work" : "Paused"). CarService "
        
        delegate?.sendMessageToUser(byPhoneNumber: currentOwner.phone, text: text)
    }
    
}
