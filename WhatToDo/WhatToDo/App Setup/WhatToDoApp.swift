//
//  WhatToDoApp.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 31.07.2024.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

@main
struct WhatToDoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_VXVDGffzaZwZcYfuKIMPjxXDjOo")
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView(viewModel: AuthViewModel(viewContext: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //                .presentPaywallIfNeeded(requiredEntitlementIdentifier: "premium")
        }
    }
}
