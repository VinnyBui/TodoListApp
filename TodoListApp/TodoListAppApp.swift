//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Vinh Bui on 3/10/24.
//

import SwiftUI

@main
struct TodoListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
