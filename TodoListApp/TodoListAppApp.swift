import SwiftUI
import CoreData

@main
struct TodoListAppApp: App {
    // Instantiate the persistence controller
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Provide the managed object context to the SwiftUI environment
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// class for handling the database
class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Database") 
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
