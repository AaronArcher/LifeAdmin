//
//  HomeView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("showOnboarding") var showOnboarding = true

    
    @State private var showNewAccount = false
    
    @State private var showActive = true
    
    @State private var showSettings = false
    
    @State private var showCategories = false
    @State private var animatePath = false
    @State private var animateBG = false
    
    @State private var selectedCategory = "None"
    
    @State private var showSave = false
    
    @EnvironmentObject var spotlight: SpotlightVM
    
    @State var showTabBar = true
    
    var body: some View {

        ZStack {
                    
                    AccountListView(showNewAccount: $showNewAccount, showActive: $showActive, showSettings: $showSettings, showCategories: $showCategories, selectedCategory: $selectedCategory, animatePath: $animatePath, animateBG: $animateBG, showSave: $showSave, showTabBar: $showTabBar)
                        .disabled(showCategories || showSave)
                        .overlay(
                            Color.black.opacity(showCategories || showSave ? 0.7 : 0)
                        )
                        .accessibilityHidden(showCategories || showSave)
                        .accessibilityAddTraits(.isModal)
            
                    

                        
                    
                    TabView(showActive: $showActive, showNewAccount: $showNewAccount)
                        .disabled(showCategories || showSave)
                        .overlay(
                            Color.black.opacity(showCategories || showSave ? 0.7 : 0)
                        )
                        .accessibilityHidden(showCategories || showSave)
                        .accessibilityAddTraits(.isModal)
                        .offset(y: showTabBar ? 0 : (Constants.isScreenLarge ? (Constants.screenHeight / 8.5) * 2 : (Constants.screenHeight / 7.5) * 2))

                    
                    if showSave {
                        VStack {
                            Text("Saved!")
                                .foregroundColor(Color("PrimaryText"))
                                .font(.title.weight(.light))
                            
                            Spacer()
                            
                            LottieView()
                                .frame(width: Constants.screenWidth / 4, height: Constants.screenWidth / 4)
                            
                            Spacer()
                            
                            Button {
                                    showSave.toggle()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: Constants.screenWidth / 3, height: 40)
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
                            .frame(width: Constants.screenWidth / 1.8 , height: Constants.screenWidth / 1.8)
                        )
                        .frame(width: Constants.screenWidth / 1.8 , height: Constants.screenWidth / 1.8)
                        .accessibilityAddTraits(.isModal)
                        .accessibilityLabel("Account saved")
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                if showSave {
                                        showSave = false
                                }
                            }
                        }
                        
                    }
                    
                    CategoriesView(selectedCategory: $selectedCategory, showCategories: $showCategories, animatePath: $animatePath, animateBG: $animateBG)
                .offset(x: showCategories ? 0 : -(Constants.screenWidth))
                        .accessibilityAddTraits(.isModal)
                    
                    
                    
                }
                .onAppear(perform: {
                    if showOnboarding {
                        spotlight.isOnboarding = true
                        spotlight.currentSpotlight = 1
                    }
                })
                .background(Color("Background"))
                .onTapGesture {
                    if spotlight.isOnboarding {
                        if spotlight.currentSpotlight >= 6 {
                            spotlight.currentSpotlight = 0
                            spotlight.isOnboarding = false
                            if showOnboarding {
                                showOnboarding = false
                            }
                        } else {
                            spotlight.currentSpotlight += 1

                        }
                    }
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
