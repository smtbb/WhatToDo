//
//  FirebaseAuthViewModel.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 31.07.2024.
//

import SwiftUI
import FirebaseAuth
import CoreData
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var confirmEmail = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoginMode = true
    @Published var isAuthenticated = false
    @Published var authErrorMessage: String?
    @Published var userEmail: String?
    
    var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.userEmail = Auth.auth().currentUser?.email
    }
    
    func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            guard email == confirmEmail else {
                authErrorMessage = "Email eşleşmiyor"
                return
            }
            guard password == confirmPassword else {
                authErrorMessage = "Şifreler eşleşmiyor"
                return
            }
            createUser()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.authErrorMessage = error.localizedDescription
                return
            }
            self.isAuthenticated = true
            self.userEmail = result?.user.email
        }
    }
    
    private func createUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.authErrorMessage = error.localizedDescription
                return
            }
            self.isAuthenticated = true
            self.userEmail = result?.user.email
            
            if let userID = result?.user.uid {
                let db = Firestore.firestore()
                db.collection("users").document(userID).setData([
                    "email": self.email
                ]) { error in
                    if let error = error {
                        print("Error adding user to Firestore: \(error)")
                    } else {
                        print("User added to Firestore successfully")
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try? Auth.auth().signOut()
            self.isAuthenticated = false
            self.userEmail = nil
        } catch {
            self.authErrorMessage = error.localizedDescription
        }
    }
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let context: NSManagedObjectContext
    private let userID: String?

    init(context: NSManagedObjectContext) {
        self.context = context
        self.userID = Auth.auth().currentUser?.uid
        fetchTasks()
    }
    
    func fetchTasks() {
        guard let userID = userID else { return }
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            self.tasks = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    func addTask(title: String, date: Date) {
        guard let userID = userID else { return }
        
        let newTask = Task(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.date = date
        newTask.isCompleted = false
        newTask.userID = userID // kullanıcı ID'sini ekleyin
        
        saveContext()
    }
    
    func deleteTasks(at offsets: IndexSet) {
        guard let userID = userID else { return }
        
        let db = Firestore.firestore()
        offsets.forEach { index in
            let task = tasks[index]
            if let taskId = task.id?.uuidString {
                // Firebase'den sil
                db.collection("tasks").document(userID).collection("userTasks").document(taskId).delete { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
            // Core Data'dan sil
            context.delete(task)
        }
        saveContext()
    }
    
    func updateTaskCompletion(task: Task, isCompleted: Bool){
        task.isCompleted = isCompleted
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
            fetchTasks() // Yeniden veri almak için
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func syncTasksToFirebase() {
        guard let userID = userID else { return }
        
        let db = Firestore.firestore()
        for task in tasks {
            let taskData: [String: Any] = [
                "id": task.id?.uuidString ?? UUID().uuidString,
                "title": task.title ?? "",
                "isCompleted": task.isCompleted,
                "date": task.date ?? Date(),
                "userID": userID // kullanıcı ID'sini ekleyin
            ]

            db.collection("tasks").document(userID).collection("userTasks").document(task.id?.uuidString ?? UUID().uuidString).setData(taskData) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
}
