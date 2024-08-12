//
//  Request.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 4.08.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class Request: ObservableObject, Identifiable {
    @Published var id: String
    @Published var fromUserID: String
    @Published var fromUserEmail: String
    @Published var toUserID: String
    @Published var toUserEmail: String
    @Published var status: String
    @Published var timestamp: Timestamp
    
    init(id: String, fromUserID: String, fromUserEmail: String, toUserID: String, toUserEmail: String, status: String, timestamp: Timestamp) {
        self.id = id
        self.fromUserID = fromUserID
        self.fromUserEmail = fromUserEmail
        self.toUserID = toUserID
        self.toUserEmail = toUserEmail
        self.status = status
        self.timestamp = timestamp
    }
}
