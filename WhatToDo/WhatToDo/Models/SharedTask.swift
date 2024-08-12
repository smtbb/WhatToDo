//
//  SharedTask.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 5.08.2024.
//

import Foundation
import FirebaseFirestore

struct SharedTask: Identifiable {
    var id: String
    var title: String
    var date: Date
    var isCompleted: Bool
    var sharedListID: String
    var userID: String
}
