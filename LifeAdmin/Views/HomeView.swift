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
    
    var body: some View {
        NavigationView {
            ZStack {
                
                AccountListView(showNewAccount: $showNewAccount, showActive: $showActive, showSettings: $showSettings, showCategories: $showCategories, selectedCategory: $selectedCategory)
                    .disabled(showCategories)
                    .overlay(
                        Color.black.opacity(showCategories ? 0.7 : 0)
                    )
                    .blur(radius: showCategories ? 3 : 0)
                    
                
                TabView(showActive: $showActive, showNewAccount: $showNewAccount)
                    .disabled(showCategories)
                    .overlay(
                        Color.black.opacity(showCategories ? 0.7 : 0)
                    )
                    .blur(radius: showCategories ? 3 : 0)
                
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
