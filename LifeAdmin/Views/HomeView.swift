//
//  HomeView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("showOnboarding") var showOnboarding = true
    
    @State private var showIntro = true
    @State private var showIntroLogo = false
    @State private var showIntroColor = true

    @EnvironmentObject var controlVM: ControlViewModel
    @EnvironmentObject var spotlight: SpotlightVM
    @EnvironmentObject var filterVM: FilterViewModel

        
    var body: some View {

        ZStack {
                    
                    AccountListView()
                        .disabled(controlVM.showCategories || controlVM.showSave)
                        .overlay(
                            Color.black.opacity(controlVM.showCategories || controlVM.showSave ? 0.7 : 0)
                        )
                        .accessibilityHidden(controlVM.showCategories || controlVM.showSave)
                        .accessibilityAddTraits(.isModal)
                        
                    
                    TabView()
                        .disabled(controlVM.showCategories || controlVM.showSave)
                        .overlay(
                            Color.black.opacity(controlVM.showCategories || controlVM.showSave ? 0.7 : 0)
                        )
                        .accessibilityHidden(controlVM.showCategories || controlVM.showSave)
                        .accessibilityAddTraits(.isModal)
                        .offset(y: controlVM.showTabBar ? 0 : (Constants.isScreenLarge ? (Constants.screenHeight / 8.5) * 2 : (Constants.screenHeight / 7.5) * 2))


                    
            if controlVM.showSave {
                        VStack {
                            Text("Saved!")
                                .foregroundColor(Color("PrimaryText"))
                                .font(.title.weight(.light))
                            
                            Spacer()
                            
                            LottieView()
                                .frame(width: Constants.screenWidth / 4, height: Constants.screenWidth / 4)
                            
                            Spacer()
                            
                            Button {
                                controlVM.showSave.toggle()
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
                                if controlVM.showSave {
                                    controlVM.showSave = false
                                }
                            }
                        }
                        
                    }
                    
                    CategoriesView()
                .offset(x: controlVM.showCategories ? 0 : -(Constants.screenWidth))
                        .accessibilityAddTraits(.isModal)

            if showIntro {
                ZStack {
                    Color("Background")
                        .ignoresSafeArea()
                        .opacity(showIntroColor ? 1 : 0)
                    
                    VStack {
                        
                        Text("LifeAdmin")
                            .font(.largeTitle.weight(.light))
                            .foregroundColor(Color("PrimaryText"))
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 8, y: 8)
                            .padding()
                        
                            Image("Logo")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 10, y: 10)
                         
                        
                    }
                    .opacity(showIntroLogo ? 1 : 0)
                    .onAppear {
                        if showIntro {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showIntroLogo = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    showIntroLogo = false
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    showIntroColor = false
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                                    showIntro = false
                            }
                        }
                    }
                    
                    
                }
            }
            
                    
                    
                    
                }
                .onAppear(perform: {
                    if showOnboarding {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                                spotlight.isOnboarding = true
                                spotlight.currentSpotlight = 1
                            
                        }
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
