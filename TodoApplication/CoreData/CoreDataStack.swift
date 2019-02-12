//
//  CoreDataStack.swift
//  TodoApplication
//
//  Created by jairo cruz on 2/6/19.
//  Copyright © 2019 jairo cruz. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores{
            (description, error) in
            guard error == nil else {
                print(error!)
                return
            }
        }
        return container
    }
    
    // MARK: primary managed save and delete operations
    var managedContext: NSManagedObjectContext{
        return container.viewContext
    }
}
