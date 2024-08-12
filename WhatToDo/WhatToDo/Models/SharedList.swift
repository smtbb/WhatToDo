//
//  SharedList.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 4.08.2024.
//

import Foundation
import FirebaseFirestore

struct SharedList: Identifiable {
    var id: String
    var title: String
    var members: [String]
    var timestamp: Timestamp
}
