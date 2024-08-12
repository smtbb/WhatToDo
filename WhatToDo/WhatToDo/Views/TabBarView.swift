//
//  TabBarView.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 1.08.2024.
//

import SwiftUI

struct TabBarView: View {
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
        }
        .padding(.top,30)
    }
}

#Preview {
    TabBarView(authViewModel: AuthViewModel(viewContext: PersistenceController.shared.container.viewContext))
}
