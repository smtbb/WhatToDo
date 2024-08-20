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
                    Image("contextWallpaper3")
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
                        
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding(.bottom, 50)
                            .padding(.top,90)
                        
                        
                        // Email Alanı
                        TextField("Email", text: $viewModel.email)
                            .padding(6)
                            .background(Color.white) // Arka plan rengini beyaz yapıyoruz.
                            .foregroundColor(.gray)
                            .cornerRadius(8) // Köşeleri yuvarlıyoruz.
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1) // Sınır çizgisi
                            )
                            .padding(.bottom, 10)
                            .padding([.leading,.trailing], 20)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        
                        // Email Onay Alanı (Sadece Kayıt Modunda)
                        if !viewModel.isLoginMode {
                            TextField("Email Onay", text: $viewModel.confirmEmail)
                                .padding(6)
                                .background(Color.white) // Arka plan rengini beyaz yapıyoruz.
                                .cornerRadius(8) // Köşeleri yuvarlıyoruz.
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1) // Sınır çizgisi
                                )
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                                .padding([.leading,.trailing], 20)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Şifre Alanı
                        SecureField("Şifre", text: $viewModel.password)
                            .foregroundColor(.gray)
                            .padding(6)
                            .background(Color.white) // Arka plan rengini beyaz yapıyoruz.
                            .cornerRadius(8) // Köşeleri yuvarlıyoruz.
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1) // Sınır çizgisi
                            )
                            .padding(.bottom, 10)
                            .padding([.leading,.trailing], 20)
                        
                        // Şifre Onay Alanı (Sadece Kayıt Modunda)
                        if !viewModel.isLoginMode {
                            SecureField("Şifre Onay", text: $viewModel.confirmPassword)
                                .foregroundColor(.gray)
                                .padding(6)
                                .background(Color.white) // Arka plan rengini beyaz yapıyoruz.
                                .cornerRadius(8) // Köşeleri yuvarlıyoruz.
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1) // Sınır çizgisi
                                )
                                .padding(.bottom, 10)
                                .padding([.leading,.trailing], 20)
                        }

                        // Hata Mesajı
                        if let errorMessage = viewModel.authErrorMessage {
                            Text(errorMessage)
                                .font(.headline)
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
                                .background(Color.brown)
                                .cornerRadius(10)
                                .padding([.leading,.trailing], 20)
                        }
                        .padding(.bottom, 10)
                        
                        // Mod Değiştirme Butonu
                        Button(action: {
                            viewModel.isLoginMode.toggle()
                        }) {
                            Text(viewModel.isLoginMode ? "Hesabınız yok mu? Kayıt Olun" : "Zaten hesabınız var mı? Giriş Yapın")
                                .font(.headline)
                                .foregroundColor(Color(UIColor(red: 72/255, green: 52/255, blue: 212/255, alpha: 1.0)))
                        }
                        // rgba(72, 52, 212,1.0)
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
