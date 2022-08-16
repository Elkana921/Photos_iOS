

import Foundation
import CoreData
import MapKit

class CoreDataManager{
    
    private init() {}
    public static let shared = CoreDataManager()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "myProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context:NSManagedObjectContext{
            persistentContainer.viewContext
        }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD
    func add(favorite: Favorites){
        saveContext()
    }
    
    func update(favorite: Favorites){
        saveContext()
    }
    
    func delete(favorite: Favorites){
        context.delete(favorite)
        saveContext()
    }
    
    func fetchFavorites() -> [Favorites]{
        
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        
        let favorites = try? context.fetch(request)
        
        print("$$$ Read CoreData: \(favorites ?? [])\n")
        
        return favorites ?? []
    }
    
    //TODO: add the fianl func doesExist()
    func doesExist(favorite: Favorites) -> Bool{

        let favorites = fetchFavorites()

        return favorites.first { $0 == favorite } == nil
    }
    
}


