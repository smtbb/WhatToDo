//
//  AuthView.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 31.07.2024.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.isAuthenticated {
            TabBarView(authViewModel: viewModel)
        } else {
            NavigationView {
                ZStack {
                    Image("contextWallpaper")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .ignoresSafeArea()
                    VStack {
                        // Başlık
                        //                    Text(viewModel.isLoginMode ? "Giriş Yap" : "Kayıt Ol")
                        //                        .font(.largeTitle)
                        //                        .fontWeight(.bold)
                        //                        .padding(.bottom, 20)
                        //                        .foregroundColor(.white)
                        Image("moon")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding(.bottom, 50)
                            .padding(.top,50)
                        // Email Alanı
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        // Email Onay Alanı (Sadece Kayıt Modunda)
                        if !viewModel.isLoginMode {
                            TextField("Email Onay", text: $viewModel.confirmEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Şifre Alanı
                        SecureField("Şifre", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        // Şifre Onay Alanı (Sadece Kayıt Modunda)
                        if !viewModel.isLoginMode {
                            SecureField("Şifre Onay", text: $viewModel.confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                        }
                        
                        // Hata Mesajı
                        if let errorMessage = viewModel.authErrorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                        
                        // Giriş/Kayıt Butonu
                        Button(action: {
                            viewModel.handleAction()
                        }) {
                            Text(viewModel.isLoginMode ? "Giriş Yap" : "Kayıt Ol")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 10)
                        
                        // Mod Değiştirme Butonu
                        Button(action: {
                            viewModel.isLoginMode.toggle()
                        }) {
                            Text(viewModel.isLoginMode ? "Hesabınız yok mu? Kayıt Olun" : "Zaten hesabınız var mı? Giriş Yapın")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        // NavigationLink
                        NavigationLink(destination: TaskListView(viewModel: TaskViewModel(context: viewModel.viewContext)), isActive: $viewModel.isAuthenticated) {
                            EmptyView()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: AuthViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
}
