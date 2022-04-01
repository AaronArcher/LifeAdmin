//
//  HomeView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct HomeView: View {
    
        
    @State private var showNewAccount = false
    
    @State private var showActive = true
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                              
                AccountListView(showNewAccount: $showNewAccount, showActive: $showActive, showSettings: $showSettings)
                
                TabView(showActive: $showActive, showNewAccount: $showNewAccount)
            }
            .ignoresSafeArea()
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
