//
//  SettingsView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 31/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @Namespace var namespace
    
    @AppStorage("isDarkMode") var isDarkMode = false
    @AppStorage("showTotalAs") var showTotalAs = "month"
        
    private var bugEmail = SupportEmail(toAddress: "aaronarcherapps@outlook.com", subject: "LifeAdmin - Support Email", messageHeader: "Please describe the bug below:")
    
    private var featureEmail = SupportEmail(toAddress: "aaronarcherapps@outlook.com", subject: "LifeAdmin - New Feature Request", messageHeader: "Please include your feature request below:")
    
    @EnvironmentObject var spotlight: SpotlightVM
//    @Binding var isOnboarding: Bool
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                //MARK: Header
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title.weight(.light))
                    }
                    .frame(width: 30, height: 30)
                    
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                        spotlight.currentSpotlight = 1
                        spotlight.isOnboarding = true
                    }, label: {
                        Image(systemName: "questionmark.square")
                            .font(.title.weight(.light))

                    })
                        .frame(width: 30, height: 30)
                    
                    
                }
                .foregroundColor(Color("PrimaryText"))
                .padding()
                
                List {
                    
                    //MARK: Display Preferences
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
                                    print("changed showtotal to month")
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
                                    print("Settings - changed showtotal to year")

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

                    //MARK: Default Contact Details
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
                
                HStack {
                    Button {
                        bugEmail.sendEmail(openURL: openURL)
                    } label: {
                        Text("Report a bug")
                            .foregroundColor(.white)
                            .fontWeight(.light)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(Color("Blue1"))
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        featureEmail.sendEmail(openURL: openURL)
                    } label: {
                        Text("Suggest a feature")
                            .foregroundColor(.white)
                            .fontWeight(.light)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(Color("Green1"))
                            )
                    }

                }
                .padding()
                
                
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
