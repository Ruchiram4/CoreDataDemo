//
//  Factory.swift
//  CoreDataManager
//
//  Created by Ruchira Macbook on 2021-10-25.
//

import Foundation
import CoreData

class Factory {
    
    static func createDBHandler(withContext: NSManagedObjectContext) -> DBHandlerProtocol {
        let dbHandler = DBHandler(withContext: withContext)
        return dbHandler
    }
    
    static func createHomeViewController(withContext: NSManagedObjectContext) -> HomeViewController {
        let homeVC = HomeViewController(withContext: withContext)
        return homeVC
    }
}
