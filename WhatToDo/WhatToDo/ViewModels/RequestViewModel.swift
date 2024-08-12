//
//  RequestViewModel.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 4.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class RequestViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private let userID = Auth.auth().currentUser?.uid
    
    @Published var requestStatus: String = ""
    @Published var requests: [Request] = []
    
    func sendRequest (to email: String) {
        guard let userID = userID, let userEmail = Auth.auth().currentUser?.email else { return }
        
        // Kullanıcının hedef email ile userIDsini bulunacağı yer
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
                self.requestStatus = "Kullanıcı Bulunamadı!"
                return
            }
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                print("Kullanıcı Bulunamadı!")
                self.requestStatus = "Kullanıcı Bulunamadı!"
                return
            }
            
            let targetUserID = document.documentID
            let targetUserEmail = document.data()["email"] as? String ?? ""
            
            let requestData: [String: Any] = [
                "fromUserID": userID,
                "fromUserEmail": userEmail,
                "toUserID": targetUserID,
                "toUserEmail": targetUserEmail,
                "status": "pending",
                "timestamp": Timestamp()
            ]
            
            self.db.collection("requests").addDocument(data: requestData) { error in
                if let error = error {
                    print("Error sending request: \(error)")
                    self.requestStatus = "Davet Gönderirken Hata Meydana Geldi"
                } else {
                    print("Request sent successfully")
                    self.requestStatus = "Davet Gönderildi"
                }
            }
        }
    }
    func fetchReceivedRequests() {
        guard let userID = userID else { return }
        
        db.collection("requests").whereField("toUserID", isEqualTo: userID).whereField("status", isEqualTo: "pending").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting requests: \(error)")
                return
            }
            
            var fetchedRequests: [Request] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                let request = Request(id: document.documentID,
                                      fromUserID: data["fromUserID"] as? String ?? "",
                                      fromUserEmail: data["fromUserEmail"] as? String ?? "",
                                      toUserID: data["toUserID"] as? String ?? "",
                                      toUserEmail: data["toUserEmail"] as? String ?? "",
                                      status: data["status"] as? String ?? "",
                                      timestamp: data["timestamp"] as? Timestamp ?? Timestamp())
                fetchedRequests.append(request)
            }
            
            DispatchQueue.main.async {
                self.requests = fetchedRequests
            }
        }
    }
    func updateRequestStatus(requestID: String, status: String, completion: @escaping (Bool) -> Void) {
           db.collection("requests").document(requestID).updateData(["status": status]) { error in
               if let error = error {
                   print("Error updating request status: \(error)")
                   completion(false)
               } else {
                   completion(true)
               }
           }
       }
}
