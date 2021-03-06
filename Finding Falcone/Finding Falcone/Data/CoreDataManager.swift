//
//  CoreDataManager.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import CoreData
import os.log

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Finding_Falcone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext? {
        self.persistentContainer.viewContext
    }
    
    private func entityDescription<T:NSManagedObject>(entity: T.Type) -> NSEntityDescription? {
        guard let moc = getContext() else { return nil }
        let entityDesc = NSEntityDescription.entity(forEntityName: String(describing: entity), in: moc)
        return entityDesc
    }
    
    func saveMainContext() {
        self.saveContext()
    }
    
    func createEntity<T: NSManagedObject>(entity: T.Type) -> NSManagedObject? {
        guard let entityDesc = self.entityDescription(entity: entity) else { return nil }
        let createdEntity = NSManagedObject.init(entity: entityDesc, insertInto: self.getContext())
        self.saveMainContext()
        return createdEntity
    }
    
    func fetchEntity<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptor: [NSSortDescriptor]? = nil) -> T? {
        let context = self.getContext()
        let entityName: String = String(describing: entity)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let searchResult = try context?.fetch(fetchRequest)
            return searchResult?.count ?? -1 > 0 ? searchResult?.first : nil
        } catch {
            os_log("Error: %@", type: .error, error.localizedDescription)
            return nil
        }
    }
    
    func fetchAllRecordsForEntity<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptor: [NSSortDescriptor]? = nil) -> [T]? {
        let context = self.getContext()
        let entityName: String = String(describing: entity)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let searchResult = try context?.fetch(fetchRequest)
            return searchResult?.count ?? -1 > 0 ? searchResult : nil
        } catch {
            os_log("Error: %@", type: .error, error.localizedDescription)
            return nil
        }
    }
}
