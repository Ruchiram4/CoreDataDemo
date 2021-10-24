//
//  DBHandlerTest.swift
//  CoreDataManagerTests
//
//  Created by Ruchira Macbook on 2021-10-23.
//

@testable import CoreDataManager
import XCTest
import CoreData


class DBHandlerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func clearDB(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "PersonEntity"))
        
        do {
            try context.execute(deleteRequest)
        }
        catch { print("Oops... Delete failed...")}
        
        let dbHandler = DBHandler(withContext: context)
        let pAlice = dbHandler.getPersonByName(name: "Alice")
        XCTAssertNil(pAlice)
    }

    func test_person() {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        clearDB()
        
        let dbHandler = DBHandler(withContext: context)
        
        let p1 = PersonEntity(context: context)
        p1.name = "Alice"
        p1.age = 20
        
        let p2 = PersonEntity(context: context)
        p2.name = "Bob"
        p2.age = 22
        
        let p3 = PersonEntity(context: context)
        p3.name = "Jim"
        p3.age = 50
        
        let p4 = PersonEntity(context: context)
        p4.name = "Mike"
        p4.age = 44
        
        //Testing of Add
        dbHandler.addPerson(person: p1)
        dbHandler.addPerson(person: p2)
        dbHandler.addPerson(person: p3)
        dbHandler.addPerson(person: p4)
        
        //Testing of Read
        let pAlice = dbHandler.getPersonByName(name: "Alice")
        XCTAssertNotNil(pAlice)
        XCTAssertEqual(pAlice?.name, "Alice")
        XCTAssertEqual(pAlice?.age, 20)
        
        //Testing of update
        p4.name = "Michael"
        p4.age = 45
        dbHandler.updatePerson(updatedPerson: p4)
        let pUpdatedMike = dbHandler.getPersonByName(name: "Michael")
                
        XCTAssertNotNil(pUpdatedMike)
        XCTAssertEqual(pUpdatedMike?.name, "Michael")
        XCTAssertEqual(pUpdatedMike?.age, 45)
        
        //Testing of delete
        dbHandler.deletePerson(person: p1)
        let p1AfterDeleting = dbHandler.getPersonByName(name: "Alice")
        XCTAssertNil(p1AfterDeleting)
        
        //Testing of get all
        let result = dbHandler.getAllPersons()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.count == 3)
        
        clearDB()
    }
   

    
}
