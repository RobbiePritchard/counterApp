//
//  CoreDataManager.swift
//  RobbieiOSCounter
//
//  Created by Robbie Pritchard on 5/6/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//


import CoreData
import UIKit

class CoreDataManager{
    
    static let shared: CoreDataManager = CoreDataManager()
    
    private lazy var moc: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }()
    
    func updateOne(counterEntity: CounterEntity, counterName: String, count: Int) -> CounterEntity{
        
        counterEntity.setValue(counterName, forKey: "name")
        counterEntity.setValue(count, forKey: "count")
        
        do {
            try moc.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return counterEntity
    }
    
    func fetchSavedData() -> [NSManagedObject]{
        var counters = [NSManagedObject]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CounterEntity")
        
        do {
            counters = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return counters
    }
    
    func saveNewCounter(counterName: String, count: Int) -> NSManagedObject{
        
        let entity = NSEntityDescription.entity(forEntityName: "CounterEntity", in: moc)
        let newCounter = NSManagedObject(entity: entity!, insertInto: moc)
        
        newCounter.setValue(counterName, forKey: "name")
        newCounter.setValue(count, forKey: "count")
        
        do {
            try moc.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return newCounter
    }
    
    func deleteOne(counter: NSManagedObject) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CounterEntity")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [CounterEntity]
        
        for object in resultData {
            if object == counter{
                moc.delete(object)
                break
            }
        }
        do {
            try moc.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CounterEntity")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do{
            try moc.execute(request)
            try moc.save()
        } catch let error as NSError  {
            print("Could not execute batch delete \(error), \(error.userInfo)")
        }
    }
    
}



