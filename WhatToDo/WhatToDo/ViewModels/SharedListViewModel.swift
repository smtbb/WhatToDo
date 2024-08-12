//
//  SharedListViewModel.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 4.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SharedListViewModel: ObservableObject {
    @Published var sharedLists: [SharedList] = []
    
    private let db = Firestore.firestore()
    private let userID = Auth.auth().currentUser?.uid

    func createSharedList(with userIDs: [String], title: String) {
        guard let userID = userID else { return }
        
        var members = userIDs
        members.append(userID)
        
        let sharedListData: [String: Any] = [
            "title": title,
            "members": members,
            "timestamp": Timestamp()
        ]
        
        db.collection("shared_lists").addDocument(data: sharedListData) { error in
            if let error = error {
                print("Error creating shared list: \(error)")
            } else {
                print("Shared list created successfully")
            }
        }
    }
    
    func fetchSharedLists() {
        guard let userID = userID else { return }
        
        db.collection("shared_lists").whereField("members", arrayContains: userID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting shared lists: \(error)")
                return
            }
            self.sharedLists = querySnapshot?.documents.compactMap { document -> SharedList? in
                let data = document.data()
                guard let title = data["title"] as? String,
                      let members = data["members"] as? [String],
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }
                return SharedList(id: document.documentID, title: title, members: members, timestamp: timestamp)
                
            } ?? []
           
        }
    }
    
    func deleteSharedList(at offsets: IndexSet) {
        offsets.forEach { index in
        let sharedList = sharedLists[index]
        let sharedListID = sharedList.id
            
            let tasksCollection = db.collection("shared_lists").document(sharedListID).collection("tasks")
            tasksCollection.getDocuments {(querySnapshot, error) in
                if let error = error {
                    print("Error getting tasks: \(error)")
                    return
                }
                let batch = self.db.batch()
                
                querySnapshot?.documents.forEach { document in
                    batch.deleteDocument(document.reference)
                }
                batch.commit { error in
                    if let error = error {
                        print("Error deleting tasks: \(error)")
                        return
                    }
                }
            }
            
            
            // Listeyi Sil
            self.db.collection("shared_lists").document(sharedListID).delete { error in
                if let error = error {
                    print("Error deleting shared list: \(error)")
                    return
                }
                self.fetchSharedLists()
            }
        }
    }
    
    func updateSharedListName(listID: String, newName: String) {
        db.collection("shared_lists").document(listID).updateData(["title": newName]) { error in
            if let error = error {
                print("Error updating list name: \(error.localizedDescription)")
            } else {
                print("List name updated successfully")
            }
        }
    }
}
