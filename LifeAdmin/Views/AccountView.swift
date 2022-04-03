//
//  AccountView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import CoreData
import SwiftUI

struct AccountView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var allAccounts: FetchedResults<AccountData>
    
    @State private var showDelete = false
    
    @State private var showEdit = false
    
    let screen = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
        
    let id: UUID
    let accountName: String
    let icon: String
    let email: String
    let phone: String
    let password: String
    let address1: String
    let address2: String
    let postcode: String
    let price: Double
    let per: String
    let paymentDay: String
    let paymentMonth: String
    let isActive: Bool
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            // Header
            ZStack(alignment: .top) {
                HeaderView(text: accountName)
                
                ZStack {
                    if isActive {
                        Circle()
                            .fill(
                                LinearGradient(colors: [Color("Blue1"), Color("Blue1"), Color("Blue2")], startPoint: .top, endPoint: .bottom)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 4, y: 4)
                    } else {
                        Circle()
                            .fill(Color("Gray1"))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 4, y: 4)

                    }
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.title.weight(.thin))
                    
                }
                .frame(width: 65, height: 65)
                .offset(y: (screen.height / 6) - 33)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2.weight(.light))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)

                    }
                    
                    Spacer()
                    
                    if isActive {
                        Button {
                            
                            showEdit = true
                            
                        } label: {
                            
                            Image(systemName: "square.and.pencil")
                                .font(.title2.weight(.light))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .offset(y: (screen.height / 6) / 2.7)
                
            }
            .padding(.bottom, 40)
            
            VStack {
                
                // Email
                AccountDetailField(title: "Email", text: email)
                
                // Phone
                AccountDetailField(title: "Phone", text: phone)
                
                // Password
                AccountDetailField(title: "Password", password: password, isPassword: true)
                
                // Address
                AccountDetailField(title: "Address", text: "\(address1)\n\(address2)\n\(postcode)", fieldHeight: 95)
                
                HStack {
                    // Price
                    AccountDetailField(title: "Price", fieldWidth: screen.width / 2.5, fieldHeight: 45, isPrice: true, price: price, per: per)
                    
                    Spacer()
                    
                    // payment date
                    if per == "" {
                        AccountDetailField(title: "Payment Date", text: "\(paymentDay) \(paymentMonth)", fieldWidth: screen.width / 2.5, fieldHeight: 45)
                    } else if per == "month" {
                        AccountDetailField(title: "Payment Date", text: "\(paymentDay)", fieldWidth: screen.width / 2.5, fieldHeight: 45)
                    } else {
                        AccountDetailField(title: "Payment Date", text: "\(paymentDay) \(paymentMonth)", fieldWidth: screen.width / 2.5, fieldHeight: 45)
                    }
                        
                    
                        
                    
                }
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        showDelete = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(.red)
                                .frame(width: screen.width / 3, height: 45)
                            Text("Delete")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Button{
                        disableAccount(id: id, accounts: allAccounts)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(isActive ? Color("Blue1") : Color("Green1"))
                                .frame(width: screen.width / 3, height: 45)
                            Text(isActive ? "Disable" : "Enable")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            
        }
        .alert("Are you sure you want to delete this account?", isPresented: $showDelete, actions: {
            Button("OK") { deleteAccount(id: id, accounts: allAccounts) }
            Button("Cancel", role: .cancel) { }
        })
        .background(Color("Background"))
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showEdit) {
            
            // Show edit view
            EditAccountView(showEditAccount: $showEdit,
                            isEditing: true,
                            id: id,
                            accountName: accountName,
                            icon: icon,
                            email: email,
                            phone: phone,
                            password: password,
                            address1: address1,
                            address2: address2,
                            postcode: postcode,
                            price: String(price),
                            per: per,
                            paymentDay:paymentDay,
                            paymentMonth: paymentMonth
            )
            
        }
    }
    
    func deleteAccount(id: UUID, accounts: FetchedResults<AccountData>) {
        
        for account in accounts {
            if account.id == id {
                moc.delete(account)
            }
        }
        do {
            try moc.save()
        } catch {
            // handle the Core Data error
            print("Error saving CoreData after delete")
        }
        
    }
    
    func disableAccount(id: UUID, accounts: FetchedResults<AccountData>) {
        
        for account in accounts {
            if account.id == id {
                account.isActive.toggle()
            }
        }
        do {
            try moc.save()
        } catch {
            // handle the Core Data error
            print("Error updating CoreData")
        }
        
    }
    
}

struct AccountView_Previews: PreviewProvider {
        
    static var previews: some View {
        AccountView(id: UUID(), accountName: "Amazon Prime", icon: "play.tv.fill", email: "test@test.com", phone: "01234 098576", password: "TestPass1", address1: "1 Test Lane", address2: "Test Town", postcode: "LE16 9EL", price: 7.99, per: "month", paymentDay: "16th", paymentMonth: "March", isActive: true)
    }
}


struct PasswordField: View {
    
    var title: String = "Email"
    @State var text: String = ""
    @State var showText = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption.weight(.light))
                .foregroundColor(Color("Blue1"))
                .padding(.leading, 10)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .frame(height: 45)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                
                if text != "" {
                    if showText {
                        Text(text)
                            .font(.title3)
                            .foregroundColor(Color("Green1"))
                            .padding(.leading, 10)
                        
                    } else {
                        SecureField("N/A", text: $text)
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
                    Button{
                        withAnimation {
                            showText.toggle()
                        }
                    } label: {
                        Image(systemName: showText ? "eye.fill" : "eye.slash.fill")
                            .font(.title3)
                            .foregroundColor(Color("Blue1"))
                    }
                }
                .padding(.trailing)
                
                
            }
            
        }
        
    }
    
}

