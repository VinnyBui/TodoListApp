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

    @State private var selectedTask: Task?
    
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
                        .padding(.leading)
                        // Edit button
                        Button("Edit") {
                            selectedTask = task
                        }
                        .padding(.leading)
                        // Delete button
                    }
                    Button("Delete") {
                        deleteTask(task: task)
                    }
                    .foregroundColor(.red)
                    .padding(.leading)
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
            .sheet(item: $selectedTask) { task in
                NavigationView {
                    TaskForm(task: task) {title, description, dueDate in editTask(title: title, description: description, dueDate: dueDate, task: task)
                        selectedTask = nil
                    }
                    .navigationTitle("Edit Task")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                selectedTask = nil
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct TaskForm: View {
            @State private var title: String
            @State private var description: String
            @State private var dueDate: Date

            let onSave: (String, String, Date) -> Void

            init(task: Task? = nil, onSave: @escaping (String, String, Date) -> Void) {
                _title = State(initialValue: task?.title ?? "")
                _description = State(initialValue: task?.taskDescription ?? "")
                _dueDate = State(initialValue: task?.dueDate ?? Date())
                self.onSave = onSave
            }

            var body: some View {
                Form {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveChanges()
                        }
                    }
                }
            }
        
        private func saveChanges() {
            onSave(title, description, dueDate)
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
    
    private func editTask(title: String, description: String, dueDate: Date, task: Task){
        task.title = title
        task.taskDescription = description
        task.dueDate = dueDate
        
        do{
            try viewContext.save()

        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

