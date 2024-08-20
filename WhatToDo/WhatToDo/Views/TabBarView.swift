//
//  TabBarView.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 1.08.2024.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct TabBarView: View {
//    @State var currentOffering: Offering?
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        TabView {
            SharedListView()
                .tabItem {
                    Label("Ortak Listeler", systemImage: "shared.with.you")
                }
            TaskListView(viewModel: TaskViewModel(context: PersistenceController.shared.container.viewContext))
                .tabItem{
                    Label("Listem", systemImage: "list.bullet.clipboard")
                }
            NotificationView()
                .tabItem{
                    Label("Bildirimler",systemImage: "bell")
                }
                .onAppear {
                    fetchCurrentOffering()
                }
//            Purchases.shared.getOfferings { offerings, error in
//                if let offer = offerings?.current, error == nil {
//                    
//                }
//            }
        }
        .padding(.top,30)
    }
}

private func fetchCurrentOffering() {
    Purchases.shared.getOfferings { offerings, error in
        if let offerings = offerings, let currentOffering = offerings.current {
            print("Current offering: \(currentOffering)")
            // Burada gelen tekliflerle ilgili işlemleri yapabilirsiniz.
            // Örneğin, bir Paywall gösterimi yapabilirsiniz.
        } else {
            if let error = error {
                print("Failed to fetch offerings: \(error.localizedDescription)")
            } else {
                print("No current offering available.")
            }
        }
    }
}

#Preview {
    TabBarView(authViewModel: AuthViewModel(viewContext: PersistenceController.shared.container.viewContext))
}
