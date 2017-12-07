//
//  Service.swift
//  CarService
//
//  Created by Egor on 21.10.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import SQLite

class Service{
    
    var id: Int?
    var car: Int
    var serviceType: Int
    var employee: String
    var date: Date
    
    init(id: Int?, car: Int, serviceType: Int, employee: String) {
        self.id = id
        self.car = car
        self.serviceType = serviceType
        self.employee = employee
        self.date = Date()
    }
    
    static let table = Table("Service")
    
    static let idExpression = Expression<Int>("id")// primary key
    static let carExpression = Expression<Int>("car")
    static let serviceTypeExpression = Expression<Int>("serviceType")
    static let employeeExpression = Expression<String>("employee")
    static let dateExpression = Expression<Date>("date")
    
    class func createTable(){
        let createTable = table.create(ifNotExists: true) { table in
            table.column(idExpression, primaryKey: .autoincrement)
            table.column(carExpression)
            table.column(serviceTypeExpression)
            table.column(employeeExpression)
            table.column(dateExpression)
            
            table.foreignKey(carExpression, references: Car.table, Car.serialNumberExpression)
            table.foreignKey(serviceTypeExpression, references: ServiceType.table, ServiceType.idExpression)
            table.foreignKey(employeeExpression, references: Employee.table, Employee.loginExpression)
        }
   
        do{
            try DataBase.shared.connection.run(createTable)
        } catch{
            print("Can't create Service table")
        }
        
    }
    
    //select Service.id, Car.brand, Car.model,ServiceType.name, Employee.name, Employee.surname from Car, Service, ServiceType,Employee Where (Car.serialNumber = Service.car) AND (ServiceType.id = Service.serviceType) AND (Employee.login = Service.employee);
    class func selectAll(){
        
    }
    
}
