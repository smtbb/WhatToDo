//
//  SettingsView.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 7.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var listTitle: String // Liste adını düzenlemek için Binding
    @State private var newName: String // Yeni liste adını tutacak State
    var listID: String // Mevcut listenin ID'si
    var sharedListViewModel: SharedListViewModel // Listeyi yöneten ViewModel
    
    init(listTitle: Binding<String>, listID: String, sharedListViewModel: SharedListViewModel) {
        _listTitle = listTitle
        _newName = State(initialValue: listTitle.wrappedValue) // Başlangıçta mevcut liste adını gösterecek
        self.listID = listID
        self.sharedListViewModel = sharedListViewModel
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Liste Adı")) {
                    TextField("Yeni Liste Adı", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Güncelle") {
                        sharedListViewModel.updateSharedListName(listID: listID, newName: newName)
                        listTitle = newName // Arayüzdeki başlığı güncelle
                        dismiss() // Ayarlar ekranını kapat
                    }
                }
            }
            .navigationBarTitle("Ayarlar", displayMode: .inline)
            .navigationBarItems(trailing: Button("İptal") {
                dismiss() // İptal durumunda ekrandan çıkış
            })
        }
    }
}
