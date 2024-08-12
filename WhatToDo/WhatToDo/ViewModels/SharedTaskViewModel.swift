//
//  SharedTaskViewModel.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 5.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SharedTaskViewModel: ObservableObject {
    @Published var tasks: [SharedTask] = []
    
    private let db = Firestore.firestore()
    private let userID = Auth.auth().currentUser?.uid
    let sharedListID: String
    
    init(sharedListID: String) {
        self.sharedListID = sharedListID
        fetchTasks()
    }
    
    func fetchTasks() {
        db.collection("shared_lists").document(sharedListID).collection("tasks").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Failed to fetch tasks: \(error)")
                return
            }
            self.tasks = querySnapshot?.documents.compactMap { document -> SharedTask? in
                let data = document.data()
                guard let title = data["title"] as? String,
                      let date = (data["date"] as? Timestamp)?.dateValue(),
                      let isCompleted = data["isCompleted"] as? Bool,
                      let userID = data["userID"] as? String else {
                    return nil
                }
                return SharedTask(id: document.documentID, title: title, date: date, isCompleted: isCompleted, sharedListID: self.sharedListID, userID: userID)
            } ?? []
        }
    }
    func addTask(title: String, date: Date) {
        guard let userID = userID else { return }
        
        let newTaskData: [String: Any] = [
            "title": title,
            "date": Timestamp(date: date),
            "isCompleted": false,
            "userID": userID
        ]
        
        db.collection("shared_lists").document(sharedListID).collection("tasks").addDocument(data: newTaskData) { error in
            if let error = error {
                print("Failed to add task: \(error)")
                return
            }
            self.fetchTasks()
        }
    }
    
    func updateTaskCompletion(task: SharedTask, isCompleted: Bool) {
        db.collection("shared_lists").document(sharedListID).collection("tasks").document(task.id).updateData(["isCompleted": isCompleted]) { error in
            if let error = error {
                print("Failed to update task: \(error)")
                return
            }
            self.fetchTasks()
        }
    }
    
    func deleteTasks (at offsets: IndexSet) {
        offsets.forEach { index in
        let task = tasks[index]
            db.collection("shared_lists").document(sharedListID).collection("tasks").document(task.id).delete { error in
                if let error = error {
                    print("Failed to delete task: \(error)")
                    return
                }
                self.fetchTasks()
            }
        }
    }
}
