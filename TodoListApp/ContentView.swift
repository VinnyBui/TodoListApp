//
//  ContentView.swift
//  TodoListApp
//
//  Created by Vinh Bui on 3/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    // State variables for the new task form
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var newTaskDueDate = Date()
    @State private var showingAddTaskSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Text(task.title ?? "Untitled")
                        Spacer()
                        // Details button
                        Button("Details") {
                            // Details view navigation placeholder
                        }
                        // Edit button
                        Button("Edit") {
                            // Edit functionality placeholder
                        }
                        .padding(.leading)
                        // Delete button
                        Button("Delete") {
                            deleteTask(task: task)
                        }
                        .foregroundColor(.red)
                        .padding(.leading)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTaskSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTaskSheet) {
                // Sheet for adding a new task
                NavigationView {
                    Form {
                        TextField("Title", text: $newTaskTitle)
                        TextField("Description", text: $newTaskDescription)
                        DatePicker("Due Date", selection: $newTaskDueDate, displayedComponents: .date)
                    }
                    .navigationTitle("New Task")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddTaskSheet = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                addTask()
                                showingAddTaskSheet = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let newTask = Task(context: viewContext)
        newTask.title = newTaskTitle
        newTask.taskDescription = newTaskDescription
        newTask.dueDate = newTaskDueDate
        newTask.isCompleted = false
        
        do {
            try viewContext.save()
            // Reset form fields after saving
            newTaskTitle = ""
            newTaskDescription = ""
            newTaskDueDate = Date()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteTask(task: Task) {
        withAnimation {
            viewContext.delete(task)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

