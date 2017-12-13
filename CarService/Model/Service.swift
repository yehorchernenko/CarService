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
            
            table.foreignKey(carExpression, references: Car.table, Car.serialNumberExpression, update: .cascade, delete: .cascade)
            //table.foreignKey(carExpression, references: Car.table, Car.serialNumberExpression)
            table.foreignKey(serviceTypeExpression, references: ServiceType.table, ServiceType.idExpression, update: .cascade, delete: .cascade)
            table.foreignKey(employeeExpression, references: Employee.table, Employee.loginExpression, update: .cascade, delete: .cascade)
        }
   
        do{
            try DataBase.shared.connection.run(createTable)
        } catch{
            print("Can't create Service table")
        }
        
    }
    
    class func insert(_ service: Service){
        let insert = table.insert(carExpression <- service.car,
                                  serviceTypeExpression <- service.serviceType,
                                  employeeExpression <- service.employee,
                                  dateExpression <- service.date)
      
        do{
            try DataBase.shared.connection.run(insert)
        } catch{
            print("Can't add new values to 'Car' table error: \(error.localizedDescription)")
        }
        
    }
    
    //select Service.id, Car.brand, Car.model,ServiceType.name, Employee.name, Employee.surname from Car, Service, ServiceType,Employee Where (Car.serialNumber = Service.car) AND (ServiceType.id = Service.serviceType) AND (Employee.login = Service.employee);
    class func selectAll(_ services: @escaping ([Service]) -> Void){
        var retrivedServices = [Service]()
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(table){
                let service = Service(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression])
                
                retrivedServices.append(service)
            }
            
        } catch{
            print("Can't retrieve all Service: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrivedServices)
        }
    }
    
    class func select(forUserLogin login: String, services: @escaping ([Service]) -> Void){
        var retrievedServices = [Service]()
    
        
        //doen't work
        let query = table.join(.leftOuter, Car.table, on: Car.ownerExpression == login).select(distinct: table[*])
        do{
            for serviceRow in try DataBase.shared.connection.prepare(query){
                let service = Service(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression])
                
                print("** \(service.car)")
                
                retrievedServices.append(service)
            }
            
        } catch{
            print("Can't retrieve all Service: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
        
    }
    
    
}
