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
    var onProcess: Bool
    var date: Date
    
    init(id: Int?, car: Int, serviceType: Int, employee: String, onProcess: Bool) {
        self.id = id
        self.car = car
        self.serviceType = serviceType
        self.employee = employee
        self.onProcess = onProcess
        self.date = Date()
    }
    
    static let table = Table("Service")
    
    static let idExpression = Expression<Int>("id")// primary key
    static let carExpression = Expression<Int>("car")
    static let serviceTypeExpression = Expression<Int>("serviceType")
    static let employeeExpression = Expression<String>("employee")
    static let onProcessExpression = Expression<Bool>("onProcess")
    static let dateExpression = Expression<Date>("date")
    
    class func createTable(){
        let createTable = table.create(ifNotExists: true) { table in
            table.column(idExpression, primaryKey: .autoincrement)
            table.column(carExpression)
            table.column(serviceTypeExpression)
            table.column(employeeExpression)
            table.column(onProcessExpression)
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
                                  onProcessExpression <- service.onProcess,
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
                let service = Service(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression])
                
                retrivedServices.append(service)
            }
            
        } catch{
            print("Can't retrieve all Service: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrivedServices)
        }
    }
    
    class func select(forUserCars cars: [Car], services: @escaping ([Service]) -> Void){
        var retrievedServices = [Service]()
    
        
        //doen't work
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(table){
                
                let service = Service(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression])
                
                let _ = cars.contains {  car in
                    if car.serialNumber == service.car{
                    retrievedServices.append(service)
                    return true
                    }
                    return false
                }
                
            }
            
        } catch{
            print("Can't retrieve all Service: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
        
    }
    
    //delete
    class func delete(byCarSerialNumber serialNumber: Int?,serviceType: Int?, selfId: Int?){
        var alice: Table!
        
        if let number = serialNumber{
            alice = table.where(carExpression == number)
        }
        
        if let type = serviceType{
            alice = table.where(serviceTypeExpression == type)
        }
        
        if let id = selfId{
            alice = table.where(idExpression == id)
        }
        
        do{
            try DataBase.shared.connection.run(alice.delete())
        } catch {
            print(">error when delete from service")
        }
    }
    
    //update
    class func updateProcess(state: Bool,byId id: Int){
        let alice = table.where(idExpression == id)
        
        do{
            try DataBase.shared.connection.run(alice.update(onProcessExpression <- state))
        } catch {
            print(">error when updating process state in service \(error.localizedDescription)")
        }
    }
    
}
