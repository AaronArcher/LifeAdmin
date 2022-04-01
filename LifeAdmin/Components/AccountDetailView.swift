//
//  AccountDetailView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI
import LocalAuthentication


struct AccountDetailField: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    var isScreenLarge: Bool {
        UIScreen.main.bounds.height > 680
    }
    
    var title: String = ""
    var text: String = ""
    @State var password = ""
    @State private var showPass = false
    var fieldWidth: CGFloat = .infinity
    var fieldHeight: CGFloat = 45
    var isPrice: Bool = false
    var price: Double = 0.0
    var per: String = "/month"
    var isPassword: Bool = false
    
    var body: some View {
        
        Group {
            
        if isPassword {
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(isScreenLarge ? .headline.weight(.light) : .caption.weight(.light))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.leading, 10)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    if password != "" {
                        if showPass {
                            Text(password)
                                .font(.title3)
                                .foregroundColor(Color("PrimaryText"))
                                .padding(.leading, 10)
                            
                        } else {
                            SecureField("N/A", text: $password)
                                .font(.title3)
                                .foregroundColor(Color("Green1"))
                                .padding(.leading, 10)
                                .disabled(true)
                                
                        }
                    } else {
                        Text("-")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.title3)
                            .padding(10)
                    }
                        
                    
                    
                    HStack {
                        Spacer()
                        
                        if password != "" {
                            Button{
                                
                                if showPass {
                                    showPass = false
                                } else {
                                    authenticate()
                                }
                                
                            } label: {
                                Image(systemName: showPass ? "eye.fill" : "eye.slash.fill")
                                    .font(.title3)
                                    .foregroundColor(Color("PrimaryText"))
                            }
                        }
                    }
                    .padding(.trailing)
                    
                    
                }
                
            }
        } else {
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(isScreenLarge ? .headline.weight(.light) : .caption.weight(.light))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.leading, 10)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: fieldHeight)
                        .frame(maxWidth: fieldWidth)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    if isPrice {
                        if price != 0.0 {
                            HStack(spacing: 2) {
                                Text("£\(price,specifier: "%.2f")")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color("PrimaryText"))
                                Text("/\(per)")
                                    .font(.caption.weight(.light))
                                    .foregroundColor(Color("PrimaryText"))
                            }
                            .padding(10)
                        } else {
                            Text("-")
                                .foregroundColor(.gray.opacity(0.7))
                                .font(.title3)
                                .padding(10)
                        }
                        
                    } else {
                        if text != "" && text != "\n\n" {
                            Text(verbatim: text)
                                .foregroundColor(Color("PrimaryText"))
                                .font(.title3)
                                .padding(10)
                        } else {
                            Text("-")
                                .foregroundColor(.gray.opacity(0.7))
                                .font(.title3)
                                .padding(10)
                        }
                    }
                    
                }
                
            }
        }
        
    }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                showPass = false
            }
        }
    
    
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // Can use biometrics
            
            let reason = "Unlock your password"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                
                if success {
                    // authentication successful
                    showPass = true
                    
                } else {
                    // authentication unsuccessful
                    print(authenticationError!.localizedDescription)
                }
            }
        } else {
            // no biometrics
            
        }
        
        
    }
    
}


