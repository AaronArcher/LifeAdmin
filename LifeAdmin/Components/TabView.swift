//
//  TabView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

import SwiftUI

struct TabView: View {
    
    @EnvironmentObject var predicateFilter: PredicateFilter
    
    @State var isActive = true
    @Binding var showActive: Bool
    @Binding var showNewAccount: Bool
    
    let height = UIScreen.main.bounds.height / 7.5
    let largeHeight = UIScreen.main.bounds.height / 8.5
    
    
    @EnvironmentObject var spotlight: SpotlightVM


    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(Color("RowBackground"))
                .shadow(color: .black.opacity(0.15), radius: 20, y: -2)
                .spotlight(enabled: spotlight.currentSpotlight == 6, title: "Switch between active and inactive/old accounts here.")
            
            // Tab Text Buttons
            HStack {
                Button {

                    predicateFilter.showActive = true
                    
                    showActive = true
                    withAnimation(.easeInOut) {
                        isActive = true
                    }
                    print(predicateFilter.showActive)
                    
                } label: {
                    Text("Active")
                        .frame(width: 100)
                        .offset(y: isActive ? -10 : 0)
                        .scaleEffect(isActive ? 1.1 : 1)
                }
                .buttonStyle(FlatButtonStyle())
                
                Spacer()
                
                Button {

                    predicateFilter.showActive = false
                    
                    showActive = false
                    withAnimation(.easeInOut) {
                        isActive = false
                    }
                    print(predicateFilter.showActive)

                } label: {
                    Text("Inactive")
                        .frame(width: 100)
                        .offset(y: isActive ? 0 : -10)
                        .scaleEffect(isActive ? 1 : 1.1)

                }
                .buttonStyle(FlatButtonStyle())

                
            }
            .font(Constants.isScreenLarge ? .title.weight(.light) : .title2.weight(.light))
            .foregroundColor(Color("TabText"))
            .padding(.horizontal, 20)
            
            
            // Circles
            HStack{
                Circle()
                    .fill(Color("Green1"))
                    .frame(width: height)
                    .frame(width: 100)
                    .offset(y: isActive ? (Constants.isScreenLarge ? largeHeight / 1.5 : height / 1.5) : (Constants.isScreenLarge ? largeHeight : height))
                    .shadow(color: .black.opacity(isActive ? 0.2 : 0), radius: 10, x: 0, y: -10)
                
                Spacer()
                
                Circle()
                    .fill(Color("Green1"))
                    .frame(width: height)
                    .frame(width: 100)
                    .offset(y: isActive ? (Constants.isScreenLarge ? largeHeight : height) : (Constants.isScreenLarge ? largeHeight / 1.5 : height / 1.5))
                    .shadow(color: .black.opacity(isActive ? 0 : 0.2), radius: 10, x: 0, y: -10)

                
            }
            .padding(.horizontal, 20)
            
            // New Account Button
            Button {
                showNewAccount = true

            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [Color("Blue1"), Color("Blue2")], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: Constants.isScreenLarge ? largeHeight : height, height: Constants.isScreenLarge ? largeHeight : height)
                    
                    Image(systemName: "plus")
                        .font(.system(size:Constants.isScreenLarge ? 60 : 50, weight: .thin))
                        .foregroundColor(.white)
                }
            }
            //MARK: Spotlight
            .spotlight(enabled: spotlight.currentSpotlight == 1, title: "Welcome to LifeAdmin! \n \n \nThe best app to keep all of your individual account information securely in one place!")
            .spotlight(enabled: spotlight.currentSpotlight == 2, title: "Set up new accounts using this button.")
            .offset(y: -height / 2)
            .shadow(color: .black.opacity(0.2), radius: 15, x: 5, y: 10)
                        
        }
        .frame(height: Constants.isScreenLarge ? largeHeight : height)
        .frame(maxHeight: .infinity, alignment:  .bottom)
        .ignoresSafeArea()
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(showActive: .constant(true), showNewAccount: .constant(false))
        
        TabView(showActive: .constant(true), showNewAccount: .constant(false))
            .previewDevice("iPhone SE (2nd generation)")

    }
}

