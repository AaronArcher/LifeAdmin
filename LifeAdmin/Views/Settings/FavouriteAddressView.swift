//
//  FavouriteAddressView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 01/04/2022.
//

import SwiftUI

struct FavouriteAddressView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("defaultAddress1") var defaultAddress1 = ""
    @AppStorage("defaultAddress2") var defaultAddress2 = ""
    @AppStorage("defaultPostcode") var defaultPostcode = ""

    @State private var newAddress1: String = ""
    @State private var newAddress2: String = ""
    @State private var newPostcode: String = ""
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
            
            Text("Set a default address to save your account information faster.")
                .font(.title3.weight(.light))
                .padding(.top)
            
            Text("Current default address number:")
                .font(.headline)
                .foregroundColor(Color("Green1"))
                .padding(.top)
            
            if defaultAddress1 == "" && defaultAddress2 == "" && defaultPostcode == "" {
                Text("No address saved...")
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
                VStack(alignment:.leading) {
                    Text(defaultAddress1)
                        .fontWeight(.light)
                    Text(defaultAddress2)
                        .fontWeight(.light)
                    Text(defaultPostcode)
                        .fontWeight(.light)

                }
                .padding(.top, -5)
                .padding(.bottom, 40)
                
            }
         
                VStack {
                   
                    TextField("Enter New Address Line 1", text: $newAddress1)
                        
                    
                    TextField("Enter New Address Line 2", text: $newAddress2)
                        
                    
                    TextField("Enter New Postcode", text: $newPostcode)
                        
                    
                    HStack {
                        Spacer()
                    
                        Button {
                            showingAlert.toggle()
                            defaultAddress1 = newAddress1
                            defaultAddress2 = newAddress2
                            defaultPostcode = newPostcode

                    } label: {
                        
                            Text("Save")
                            .fontWeight(.light)
                    }
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 2, y: 3)
                )
            
            

            Text("*This will not change existing accounts")
                .font(.footnote)
            
            
            Spacer()
        }
        .alert("Address saved!", isPresented: $showingAlert, actions: {
            Button("OK", role: .cancel) { }

        })
        .foregroundColor(Color("PrimaryText"))
        .padding([.top, .horizontal])
        .background(Color("Background").ignoresSafeArea())
        
    }
}

struct FavouriteAddressView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAddressView()
    }
}
