//
//  SavedContactDetailsView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 01/04/2022.
//

import SwiftUI

struct DefaultPhoneView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("defaultPhone") var defaultPhone = ""
    
    @State private var newPhone: String = ""
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
            
            Text("Set a default phone number to save your account information faster.")
                .font(.title3.weight(.light))
                .padding(.top)
            
            Text("Current default phone number:")
                .font(.headline)
                .foregroundColor(Color("Green1"))
                .padding(.top)
            
            if defaultPhone == "" {
                Text("No phone number saved...")
                    .fontWeight(.light)
                    .padding(.top, -5)
                    .padding(.bottom, 40)

            } else {
                HStack {
                    Text(defaultPhone)
                      
                    Spacer()
                    
                    Button {
                        defaultPhone = ""
                    } label: {
                        Text("Clear")
                            .fontWeight(.light)
                            .foregroundColor(Color("PrimaryText"))
                    }

                }
                .padding(.top, -5)
                .padding(.bottom, 40)
                .padding(.trailing)
            }
         
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color("RowBackground"))
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 2, y: 3)
                    .frame(height: 40)
                
                HStack {
                   
                    TextField("Enter New Phone Number", text: $newPhone)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                    
                        Button {
                            showingAlert.toggle()
                            defaultPhone = newPhone
                            
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
        .alert("Phone number saved!", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel) { }

        })
        .foregroundColor(Color("PrimaryText"))
        .padding([.top, .horizontal])
        .background(Color("Background").ignoresSafeArea())
        
    }
}

struct SavedContactDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPhoneView()
    }
}
