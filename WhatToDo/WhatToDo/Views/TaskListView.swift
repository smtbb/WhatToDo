//
//  TaskListView.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 31.07.2024.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var newTaskTitle = ""
    @State private var newTaskDate = Date()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            NavigationView {
                    VStack {
                        List {
                            ForEach(viewModel.tasks) { task in
                                HStack {
                                    Button(action: {
                                        viewModel.updateTaskCompletion(task: task, isCompleted: !task.isCompleted)
                                    }) {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(.plain)
                                    VStack {
                                        Text(task.title ?? "Untitled")
                                        Text(task.date ?? Date(), style: .date)
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
                            .padding(.trailing)
                            
                        }
                        .padding(.leading)
                        HStack{
                            DatePicker("", selection: $newTaskDate, displayedComponents: .date)
                                .labelsHidden()
                            Button {
                                viewModel.syncTasksToFirebase()
                            } label: {
                                ZStack(alignment: .leading) {
                                    Text("Data'ya Yazdır")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding()
                                        .padding(.leading, 52)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(colorScheme == .dark ? .white : .black)
                                        }
                                    Image(systemName: "tray.fill")
                                        .frame(width: 52, height: 52)
                                        .foregroundColor(colorScheme == .dark ? .black : .white)
                                        .background(colorScheme == .dark ? .white : .black)
                                        .cornerRadius(26)
                                        .offset(x: -1)
                                }
                            }
                        }
                        
                    }
                    .padding(.bottom,20)
            }
            .navigationBarBackButtonHidden()

    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskViewModel(context: PersistenceController.shared.container.viewContext))
    }
}

