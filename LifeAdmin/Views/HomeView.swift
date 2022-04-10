//
//  HomeView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct HomeView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    
    @State private var showNewAccount = false
    
    @State private var showActive = true
    
    @State private var showSettings = false
    
    @State private var showCategories = false
    
    @State private var selectedCategory = "None"
    
    @State private var showSave = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                AccountListView(showNewAccount: $showNewAccount, showActive: $showActive, showSettings: $showSettings, showCategories: $showCategories, selectedCategory: $selectedCategory, showSave: $showSave)
                    .disabled(showCategories || showSave)
                    .overlay(
                        Color.black.opacity(showCategories || showSave ? 0.7 : 0)
                    )
                    .blur(radius: showCategories ? 3 : 0)
                    
                
                TabView(showActive: $showActive, showNewAccount: $showNewAccount)
                    .disabled(showCategories || showSave)
                    .overlay(
                        Color.black.opacity(showCategories || showSave ? 0.7 : 0)
                    )
                    .blur(radius: showCategories ? 3 : 0)
                
                if showSave {
                    VStack {
                        Text("Saved!")
                            .foregroundColor(Color("PrimaryText"))
                            .font(.title.weight(.light))
                        
                        Spacer()
                        
                        LottieView()
                            .frame(width: screenWidth / 4, height: screenWidth / 4)
                        
                        Spacer()
                        
                        Button {
                                showSave.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: screenWidth / 3, height: 40)
                                    .foregroundColor(Color("Blue1"))
                                Text("OK")
                                    .foregroundColor(.white)
                            }
                                
                        }
                        

                    }
                    .padding()
                    .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("Background"))
                        .frame(width: screenWidth / 1.8 , height: screenWidth / 1.8)
                    )
                    .frame(width: screenWidth / 1.8 , height: screenWidth / 1.8)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if showSave {
                                    showSave = false
                            }
                        }
                    }
                }
                
                CategoriesView(selectedCategory: $selectedCategory, showCategories: $showCategories)
                    .offset(x: showCategories ? 0 : -(screenWidth))
                
                
            }
            .background(Color("Background"))
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        HomeView()
            .previewDevice("iPhone SE (2nd generation)")
    }
}
