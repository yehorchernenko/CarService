//
//  ServiceType.swift
//  CarService
//
//  Created by Egor on 21.10.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import SQLite

class ServiceType{
    var id: Int?
    var name: String
    var description: String
    var price: Double
    
    init(id: Int?, name: String,description: String, price: Double) {
        if let checkedId = id{
            self.id = checkedId
        }
        self.name = name
        self.description = description
        self.price = price
    }
    
    static let table = Table("ServiceType")
    
    static let idExpression = Expression<Int>("id")
    static let nameExpression = Expression<String>("name")
    static let descriptionExpression = Expression<String>("description")
    static let priceExpression = Expression<Double>("price")
    
    //CREATE TABLE ServiceType IF NOT EXISTS(id NOT NULL PRIMARY KEY INT AUTOINCREMENT, name ....
    class func createTable(){
        let table = self.table.create(ifNotExists: true) {table in
            table.column(idExpression, primaryKey: .autoincrement)
            table.column(nameExpression)
            table.column(descriptionExpression)
            table.column(priceExpression)
        }
        
        do{
            try DataBase.shared.connection.run(table)
        } catch {
            print("Can't create ServiceType table \(error.localizedDescription)")
        }
    }
    
    //INSERT INTO ServiceType
    class func insert(_ serviceType: ServiceType){
        let insert = table.insert(nameExpression <- serviceType.name,
                                descriptionExpression <- serviceType.description,
                                priceExpression <- serviceType.price)
        
        do{
            try DataBase.shared.connection.run(insert)
            print("New data were inserted")
        } catch {
            print("Can't insert into ServiceType table \(error.localizedDescription)")
        }
        
    }
    
    //SELECT * FROM ServiceType
    class func selectAll(services: @escaping ([ServiceType]) -> Void){
        var retrivedServices = [ServiceType]()
    
        do{
            for service in try DataBase.shared.connection.prepare(table){
                let serviceType = ServiceType(id: service[idExpression], name: service[nameExpression], description: service[descriptionExpression], price: service[priceExpression])
                
                retrivedServices.append(serviceType)
            }
            
            
        } catch {
            print("Selection error in ServiceType \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            services(retrivedServices)
        }
    }
    
    
    //DELTE
    
    class func delete(byId id: Int){
        let alice = table.where(idExpression == id)
        do{
            try DataBase.shared.connection.run(alice.delete())
            Service.delete(byCarSerialNumber: nil, serviceType: id, selfId: nil)
        } catch {
            print(">error when deleting service type: \(error.localizedDescription)")
        }
        
    }
    
    
    
    
    
}
