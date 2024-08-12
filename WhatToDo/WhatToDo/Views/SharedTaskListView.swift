//
//  SharedTaskListView.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 5.08.2024.
//

import SwiftUI

struct SharedTaskListView: View {
    @ObservedObject var viewModel: SharedTaskViewModel
    @ObservedObject var sharedListViewModel: SharedListViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var newTaskTitle = ""
    @State private var newTaskDate = Date()
    @State private var isEditingTitle = false
    @State private var newListTitle = ""
    @State private var showSettingsSheet = false
    
    var body: some View {
            VStack {
                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Button (action: {
                                viewModel.updateTaskCompletion(task: task, isCompleted: !task.isCompleted)
                            }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                            VStack(alignment: .leading) {
                                Text(task.title)
                                Text(task.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteTasks)
                }
                HStack {
                    TextField("Yeni Görev", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    DatePicker("", selection: $newTaskDate, displayedComponents: .date)
                        .labelsHidden()
                    Button(action: {
                        viewModel.addTask(title: newTaskTitle, date: newTaskDate)
                        newTaskTitle = ""
                        newTaskDate = Date()
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 39, height: 26)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .background(colorScheme == .dark ? .white : .black)
                            .cornerRadius(26)
                            .offset(x: -1)
                    }
                }
                .padding()
                Button {
                    showSettingsSheet.toggle()
                } label: {
                    Text("Ayarlar")
                        .font(.system(size: 16, weight: .semibold))
                        .accentColor(.black)
                }
                .padding([.bottom,.top],8)
                .padding([.trailing,.leading],100)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.bottom,20)
            .navigationBarTitle("Liste Detay", displayMode: .inline)
            .sheet(isPresented: $showSettingsSheet) {
                            SettingsView(
                                listTitle: .constant("Mevcut Liste Adı"), // Bu ad liste başlığıyla değiştirilmeli
                                listID: viewModel.sharedListID,
                                sharedListViewModel: sharedListViewModel
                            )
                        }
    }
}

