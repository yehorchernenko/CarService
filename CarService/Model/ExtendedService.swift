//
//  ExtendedService.swift
//  CarService
//
//  Created by Egor on 19.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import SQLite

class ExtendedService: Service{
    
    //MARK: - Car properties
    var carOwner: String
    var carBrand: String
    var carModel: String
    var carColor: String
    //pk is car prop
    
    //MARK: - Owner
    let ownerName: String
    let ownerSurname: String
    

    //MARK: - Employee
    var employeeName: String
    var employeeSurname: String
    var employeePosition: String
    //pk is employee prop
    
    //MARK: - Service type
    var typeName: String
    var typeDescription: String
    var typePrice: Double
    //pk is serviceType prop

    
    init(id: Int?, car: Int, serviceType: Int, employee: String, onProcess: Bool,carOwner: String, carBrand: String,carModel: String,carColor: String,ownerName: String,ownerSurname: String,employeeName: String,employeeSurname: String,employeePosition: String,typeName: String,typeDescription: String,typePrice: Double) {
        self.carOwner = carOwner
        self.carBrand = carBrand
        self.carModel = carModel
        self.carColor = carColor
        
        self.ownerName = ownerName
        self.ownerSurname = ownerSurname
        
        self.employeeName = employeeName
        self.employeeSurname = employeeSurname
        self.employeePosition = employeePosition
        
        self.typeName = typeName
        self.typeDescription = typeDescription
        self.typePrice = typePrice
        
        
        super.init(id: id, car: car, serviceType: serviceType, employee: employee, onProcess: onProcess)

    }
    
    class func selectAllEX(_ services: @escaping ([ExtendedService]) -> Void){
        var retrivedServices = [ExtendedService]()
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])
        
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(query){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
               
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                retrivedServices.append(service)
            }
            
        } catch{
            print("Can't retrieve all Service: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrivedServices)
        }
    }
    
    
    class func selectEX(forUserCars cars: [Car], services: @escaping ([ExtendedService]) -> Void){
        var retrivedServices = [ExtendedService]()
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])
        
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(query){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                let _ = cars.contains {  car in
                    if car.serialNumber == service.car{
                        retrivedServices.append(service)
                        return true
                    }
                    return false
                }
            }
            
        } catch{
            print("Can't retrieve all Service: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrivedServices)
        }
    }
    
    class func selectEX(byId id: Int, services: @escaping ([ExtendedService]) -> Void){
        var retrievedServices = [ExtendedService]()

        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])

        
        let alice = query.where(idExpression == id).order(idExpression.asc)
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(alice){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                retrievedServices.append(service)
            }
        } catch {
            print(">error when retreiving Services for id, error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
    }
    
    class func selectEX(bySerialNumber serialNumber: Int, services: @escaping ([ExtendedService]) -> Void){
        var retrievedServices = [ExtendedService]()
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])

        
        let alice = query.where(carExpression == serialNumber).order(carExpression.asc)
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(alice){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                
                retrievedServices.append(service)
            }
        } catch {
            print(">error when retreiving Services for id, error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
    }
    
    class func selectEX(byServiceTypeId serviceTypeId: Int, services: @escaping ([ExtendedService]) -> Void){
        var retrievedServices = [ExtendedService]()
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])

        let alice = query.where(serviceTypeExpression == serviceTypeId).order(idExpression.asc)
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(alice){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                retrievedServices.append(service)
            }
        } catch {
            print(">error when retreiving Services for id, error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
    }
    
    class func selectEX(byEmployeeLogin login: String, services: @escaping ([ExtendedService]) -> Void){
        var retrievedServices = [ExtendedService]()
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])

        let alice = query.where(employeeExpression == login).order(employeeExpression.asc)
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(alice){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                retrievedServices.append(service)
            }
        } catch {
            print(">error when retreiving Services for id, error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
    }
    
    class func selectEX(byProcessState state: Bool, services: @escaping ([ExtendedService]) -> Void){
        var retrievedServices = [ExtendedService]()
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])
        let alice = query.where(onProcessExpression == state).order(idExpression.asc)
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(alice){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                retrievedServices.append(service)
            }
        } catch {
            print(">error when retreiving Services for id, error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
    }
    
    class func selectEX(fromDate from: Date, to: Date, services: @escaping ([ExtendedService]) -> Void){
        var retrievedServices = [ExtendedService]()
        
        print("**from \(from)")
        print("**to \(to)")
        
        let query = table.join(Car.table, on: Car.table[Car.serialNumberExpression] == table[carExpression])

        let alice = query.filter(from...to ~= dateExpression)
        
        do{
            for serviceRow in try DataBase.shared.connection.prepare(alice){
                
                let ownerInfo = Owner.selectAllFrom(login: serviceRow[Car.ownerExpression])
                let employeeInfo = Employee.selectEmployeeFromLogin(login: serviceRow[employeeExpression])
                let serviceTypeInfo = ServiceType.selectAllFrom(id: serviceRow[serviceTypeExpression])
                
                let service = ExtendedService(id: serviceRow[idExpression], car: serviceRow[carExpression], serviceType: serviceRow[serviceTypeExpression], employee: serviceRow[employeeExpression],onProcess: serviceRow[onProcessExpression], carOwner: serviceRow[Car.ownerExpression], carBrand: serviceRow[Car.brandExpression], carModel: serviceRow[Car.modelExpression], carColor: serviceRow[Car.colorExpression], ownerName: ownerInfo!.name, ownerSurname: ownerInfo!.surname, employeeName: employeeInfo!.name, employeeSurname: employeeInfo!.surname, employeePosition: employeeInfo!.position, typeName: serviceTypeInfo!.name, typeDescription: serviceTypeInfo!.description, typePrice: serviceTypeInfo!.price)
                
                retrievedServices.append(service)
            }
        } catch {
            print(">error when retreiving Services for id, error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrievedServices)
        }
    }
}

