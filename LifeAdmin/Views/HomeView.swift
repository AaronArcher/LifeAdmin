//
//  HomeView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct HomeView: View {
    
    let screenSize = UIScreen.main.bounds.width
    
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
                        Button {
                            withAnimation {
                                showSave.toggle()
                            }
                        } label: {
                            Text("OK")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("Background"))
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if showSave {
                                withAnimation {
                                    showSave = false
                                }
                            }
                        }
                    }
                }
                
                CategoriesView(selectedCategory: $selectedCategory, showCategories: $showCategories)
                    .offset(x: showCategories ? 0 : -(screenSize))
                
                
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
