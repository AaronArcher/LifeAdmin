//
//  TabView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

import SwiftUI

struct TabView: View {
    
    @EnvironmentObject var filterVM: FilterViewModel
    @EnvironmentObject var controlVM: ControlViewModel
    
    @State var isActive = true
    
    let height = UIScreen.main.bounds.height / 7.5
    let largeHeight = UIScreen.main.bounds.height / 8.5
    
    
    @EnvironmentObject var spotlight: SpotlightVM


    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(Color("RowBackground"))
                .shadow(color: .black.opacity(0.15), radius: 20, y: -2)
                .spotlight(enabled: spotlight.currentSpotlight == 6, title: "Switch between active or inactive accounts here.")
            
            // Tab Text Buttons
            HStack {
                Button {

                    filterVM.showActive = true
                    
                    withAnimation(.easeInOut) {
                        isActive = true
                    }
                    
                } label: {
                    Text("Active")
                        .frame(width: 100)
                        .offset(y: isActive ? -10 : 0)
                        .scaleEffect(isActive ? 1.1 : 1)
                        .dynamicTypeSize(.large)

                }
                .buttonStyle(FlatButtonStyle())
                
                Spacer()
                
                Button {

                    filterVM.showActive = false
                    
                    withAnimation(.easeInOut) {
                        isActive = false
                    }

                } label: {
                    Text("Inactive")
                        .frame(width: 100)
                        .offset(y: isActive ? 0 : -10)
                        .scaleEffect(isActive ? 1 : 1.1)
                        .dynamicTypeSize(.large)

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
                controlVM.showNewAccount = true

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
            .spotlight(enabled: spotlight.currentSpotlight == 1, title: "Welcome to LifeAdmin! \n \n \nThe ultimate app to track all of your account information in one place!")
            .spotlight(enabled: spotlight.currentSpotlight == 2, title: "Create new accounts using this button.")
            .offset(y: -height / 2)
            .shadow(color: .black.opacity(0.2), radius: 15, x: 5, y: 10)
                        
        }
        .frame(height: Constants.isScreenLarge ? largeHeight : height)
        .frame(maxHeight: Constants.screenHeight, alignment:  .bottom)
        .ignoresSafeArea()
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
        
        TabView()
            .previewDevice("iPhone SE (2nd generation)")

    }
}

