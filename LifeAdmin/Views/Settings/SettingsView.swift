//
//  SettingsView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 31/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Namespace var namespace
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("showTotalAs") var showTotalAs = "month"
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("PrimaryText"))
                            .font(.title.weight(.light))
                    }
                    .frame(width: 30, height: 30)
                    
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.largeTitle)
                        .foregroundColor(Color("PrimaryText"))
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 30, height: 30)
                    
                    
                }
                .padding()
                
                List {
                    
                    Section(content: {
                        
                        // Dark Mode
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .tint(Color("Green1"))
                            .font(.subheadline)
                        
                        // Total
                        HStack {
                            Text("Show total per")
                                .font(.callout)
                            
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Button {
                                    withAnimation {
                                        showTotalAs = "month"
                                    }
                                } label: {
                                    if showTotalAs == "month" {
                                        Text("Month")
                                            .font(.callout)
                                            .bold()
                                            .foregroundColor(Color("Green1"))
                                    } else {
                                        Text("Month")
                                            .font(.callout)

                                    }
                                    
                                }
                                .buttonStyle(FlatButtonStyle())
                                .padding(3)
                                
                                if showTotalAs == "month" {
                                    Rectangle()
                                        .frame(width: 35 ,height: 1)
                                        .matchedGeometryEffect(id: "underline", in: namespace)
                                }
                            }
                            
                            VStack(spacing: 0) {
                                Button {
                                    withAnimation {
                                        showTotalAs = "year"
                                    }
                                } label: {
                                    if showTotalAs == "year" {
                                        Text("Year")
                                            .font(.callout)
                                            .bold()
                                            .foregroundColor(Color("Green1"))
                                    } else {
                                        Text("Year")
                                            .font(.callout)
                                        
                                    }
                                }
                                .buttonStyle(FlatButtonStyle())
                                .padding(3)
                                
                                if showTotalAs == "year" {
                                    Rectangle()
                                        .frame(width: 25 ,height: 1)
                                        .matchedGeometryEffect(id: "underline", in: namespace)
                                }
                            }
                            
                        }
                        
                    }, header: {
                        Text("Display Preferences")
                            .foregroundColor(Color("Green1"))
                        
                        
                    })
                        .listRowSeparator(.hidden)

                    
                    Section {
                        
                        // Email Address
                        NavigationLink {
                            FavouriteEmailView()
                            
                        } label: {
                            Text("Email Address")
                                .font(.subheadline)
                        }
                        
                        // Phone Number
                        NavigationLink {
                            DefaultPhoneView()
                            
                        } label: {
                            Text("Phone Number")
                                .font(.subheadline)
                            
                        }
                        
                        // Address
                        NavigationLink {
                            FavouriteAddressView()
                            
                        } label: {
                            Text("Address")
                                .font(.subheadline)
                            
                        }
                        
                    } header: {
                        Text("Default Contact Details")
                            .foregroundColor(Color("Green1"))
                    }
                    .listRowSeparator(.hidden)
                    
                    
                }
                .foregroundColor(Color("PrimaryText"))
                
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(Color("Background").ignoresSafeArea())
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
