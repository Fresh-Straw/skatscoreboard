//
//  Persistence.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 28.08.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SkatScoreboard")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
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
    }
    
    private static func defaultCompletionHandler(error: Error?) {
        if let error = error {
            print("PERSISTANCE ERROR: " + error.localizedDescription)
        }
    }
    
    func save(onComplete completion: @escaping (Error?) -> () = defaultCompletionHandler) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, onComplete completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(onComplete: completion)
    }
}

extension Scoreboard {
    func getPlayers(context: NSManagedObjectContext) -> [Player] {
        let set = playersRaw as? Set<PlayerInScoreboard> ?? []
        return set.sorted {
            $0.order < $1.order
        }.map {
            $0.player!
        }
        
        
//        let pFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
//        pFetch.predicate = NSPredicate(format: "tookPartIn.scoreboard = %@", self)
//        // pFetch.sortDescriptors = [NSSortDescriptor(keyPath: \Player.tookPartIn, ascending: true)]
//        do {
//            let players = try context.fetch(pFetch) as! [Player]
//            return players
//        } catch {
//            // TODO
//            return []
//        }
    }
}
