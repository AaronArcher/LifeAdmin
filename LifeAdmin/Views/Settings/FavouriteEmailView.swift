//
//  FavouriteEmailView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 01/04/2022.
//

import SwiftUI

struct FavouriteEmailView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("defaultEmail") var defaultEmail = ""
    
    @State private var newEmail: String = ""
    @State private var showingAlert = false


    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Button {
                   dismiss()
                } label: {

                    HStack {
                        Image(systemName: "chevron.left")
                        
                        Text("back")
                    }
                        .font(.body.weight(.light))
                }
                Spacer()
            
            }
            .padding(.top, 10)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            Rectangle()
                .foregroundColor(Color("Green1"))
                .frame(height: 1)
            
            Text("Set a default email address to save your account information faster.")
                .font(.title3.weight(.light))
                .padding(.top)
            
            Text("Current default email address:")
                .font(.headline)
                .foregroundColor(Color("Green1"))
                .padding(.top)
            
            if defaultEmail == "" {
                Text("No email address saved...")
                    .fontWeight(.light)
//                    .padding(10)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            .foregroundColor(Color("RowBackground"))
//                            .shadow(color: .black.opacity(0.15), radius: 5, x: 2, y: 3)
//                    )
                    .padding(.top, -5)
                    .padding(.bottom, 40)

            } else {
                Text(defaultEmail)
                    .padding(.top, -5)
                    .padding(.bottom, 40)
                
            }
         
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color("RowBackground"))
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 2, y: 3)
                    .frame(height: 40)
                
                HStack {
                   
                    TextField("Enter New Email Address", text: $newEmail)
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    
                        Button {
                            showingAlert.toggle()
                            defaultEmail = newEmail
                            
                    } label: {
                        
                            Text("Save")
                            .fontWeight(.light)
                    }
                }
                .padding(.horizontal)
            }
            

            Text("*This will not change existing accounts")
                .font(.footnote)
            
            
            Spacer()
        }
        .alert("Email Address saved!", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel) { }

        })
        .foregroundColor(Color("PrimaryText"))
        .padding([.top, .horizontal])
        .background(Color("Background").ignoresSafeArea())
        
    }
}

struct FavouriteEmailView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteEmailView()
    }
}
