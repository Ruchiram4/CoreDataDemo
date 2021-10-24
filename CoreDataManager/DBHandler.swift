//
//  DBHandler.swift
//  CoreDataManager
//
//  Created by Ruchira Macbook on 2021-10-23.
//

import Foundation
import CoreData

protocol DBHandlerProtocol {
    
    func addPerson(name: String, age: Int);
    func addPerson(person: PersonEntity);
    func deletePerson(person: PersonEntity);
    func updatePerson(updatedPerson: PersonEntity);
    func getPersonByName(name: String) -> PersonEntity?;
    func getAllPersons() -> [PersonEntity]?;
}

class DBHandler: DBHandlerProtocol {
   
    weak var context:NSManagedObjectContext?
    
    init(withContext: NSManagedObjectContext) {
        self.context = withContext
    }
    
    func addPerson(person: PersonEntity) {
        
        do {
            try context?.save()
        }
        catch{
            print("Add person failed")
        }
    }
    
    func addPerson(name: String, age: Int) {
        let person = PersonEntity(context: context!)
        person.name = name
        person.age = Int16(age)
        addPerson(person: person)
    }
    
    func deletePerson(person: PersonEntity) {
        
        context?.delete(person)
        
    }
    
    func updatePerson(updatedPerson: PersonEntity) {
        do {
            try context?.save()
        }
        catch{
            print("Person update failed.")
        }
    }
    
    func getPersonByName(name: String) -> PersonEntity? {
        
        let predicate = NSPredicate(format: "name == '\(name)'")
        let fetchRequest = NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
        fetchRequest.predicate = predicate
        
        do {
            let result = try context?.fetch(fetchRequest)
            return result?.first
        }
        catch {
            print("Get person by name failed...")
        }
        
        return nil
        
    }
    
    func getAllPersons() -> [PersonEntity]? {
        
        let fetchRequest = NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
        
        do {
            let results = try context?.fetch(fetchRequest)
            return results
        }
        catch {
            print("Oops...Get all persons failed...")
        }
        
        return nil
    }
    
}
