//
//  AccountView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import CoreData
import SwiftUI
import LocalAuthentication
import KeychainAccess


struct AccountView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var allAccounts: FetchedResults<AccountData>
    
    @State private var showDelete = false
    
    @State private var showEdit = false
    
    let screen = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
        
    let id: UUID
    let accountName: String
    let icon: String
    let category: String
    let email: String
    let phone: String
    @State var password: String = ""
    let address1: String
    let address2: String
    let postcode: String
    let price: Double
    let per: String
    let paymentDay: String
    let paymentMonth: String
    let isActive: Bool
    
    @State private var showPass = false

    let keychain = Keychain(service: "AaronArcher.LifeAdmin").synchronizable(true)
    
    @State private var showSave = false
    
    @Binding var showTabBar: Bool


    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            //MARK: Header
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
                .onTapGesture {
                    print(password)
                }
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2.weight(.light))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .dynamicTypeSize(.medium)


                    }
                    
                    Spacer()
                    
                    if isActive {
                        Button {
                            
                            authenticate(reason: "Unlock to edit your account details", authenticatingPassword: false)
                            
                        } label: {
                            
                            Image(systemName: "square.and.pencil")
                                .font(.title2.weight(.light))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .dynamicTypeSize(.medium)
                                .accessibilityLabel("Edit Account")

                        }
                    }
                    
                }
                .padding(.horizontal)
                .offset(y: (screen.height / 6) / 2.7)
                
            }
            .padding(.bottom, 20)
            
            //MARK: Category
            if category != "None" && !category.isEmpty {
                HStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Category:")
                            .foregroundColor(Color("Green1"))
                        Text(category)
                            .bold()
                    }
                    .foregroundColor(Color("PrimaryText"))
                    .font(.caption)
                }
                .padding(.horizontal, 20)
                .padding(.top, -20)
            }
            
            
            VStack {
                
                ScrollView(showsIndicators: false) {
                    
                //MARK: Email
                AccountDetailField(title: "Email", text: email)
                
                //MARK: Phone
                AccountDetailField(title: "Phone", text: phone)
                
                //MARK: Secure Password
                VStack(alignment: .leading, spacing: 2) {
                    Text("Password")
                        .font(Constants.isScreenLarge ? .footnote.weight(.light) : .caption.weight(.light))
                        .foregroundColor(Color("PrimaryText"))
                        .padding(.leading, 10)
                    
                    ZStack(alignment: .leading) {

                        if password != "" {
                            if showPass {
                                Text(password)
                                    .font(.title3)
                                    .foregroundColor(Color("PrimaryText"))
                                    .padding(10)
                                    .lineLimit(1)


                            }
                            else {
                                SecureField("N/A", text: $password)
                                    .font(.title3)
                                    .foregroundColor(Color("Green1"))
                                    .padding(10)
                                    .disabled(true)
                                    .lineLimit(1)
                                    .accessibilityLabel("Password is hidden, unlock to view")

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
                                        authenticate(reason: "Unlock your password", authenticatingPassword: true)
                                    }
                                    
                                } label: {
                                    Image(systemName: showPass ? "eye.fill" : "eye.slash.fill")
                                        .font(.title3)
                                        .foregroundColor(Color("PrimaryText"))
                                        .accessibilityLabel(showPass ? "Hide password" : "Unlock password")
                                }
                            }
                        }
                        .padding(.trailing)
                        
                        
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(minHeight: 45)
                            .foregroundColor(Color("RowBackground"))
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    )
                    
                }
                
                //MARK: Address
                AccountDetailField(title: "Address", text: "\(address1)\n\(address2)\n\(postcode)")

                        HStack(alignment: .top) {
                        //MARK: Price
                        AccountDetailField(title: "Price", isPrice: true, price: price, per: per)

                        Spacer()

                        //MARK: payment date
                        if per == "" {
                            AccountDetailField(title: "Payment Date", text: "\(paymentDay) \(paymentMonth)")
                        } else if per == "month" {
                            AccountDetailField(title: "Payment Date", text: "\(paymentDay)")
                        } else {
                            AccountDetailField(title: "Payment Date", text: "\(paymentDay) \(paymentMonth)")
                        }


                        }
                    
                Color.clear
                    .frame(height: 30)
                
            }
                .frame(maxHeight: screen.height / 1.7)
                .padding(.bottom, 10)
                
                
                //MARK: Delete/Disable Buttons
                HStack {
                    
                    Spacer()
                    
                    Button {
                        showDelete = true
                        Constants.deleteHaptic()
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
        .onAppear(perform: {

            withAnimation(.spring()) {
                showTabBar = false
            }
            
            do {
                password = try keychain.get("\(id)") ?? ""

            } catch let error {
                print("error: \(error)")
            }

        })
        .onChange(of: showEdit) { _ in
            do {
                password = try keychain.get("\(id)") ?? ""

            } catch let error {
                print("error: \(error)")
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                showPass = false
                showEdit = false
            }
        }
        .background(Color("Background"))
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showEdit) {
            
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
                            price: price == 0 ? "" : String(price),
                            per: per,
                            paymentDay:paymentDay,
                            paymentMonth: paymentMonth,
                            selectedCategory: category,
                            showSave: $showSave
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
    
    func authenticate(reason: String, authenticatingPassword: Bool) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // Can use biometrics
            
            let reason = reason
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                
                if success {
                    // authentication successful
                    if authenticatingPassword {
                        showPass.toggle()
                    } else {
                        showEdit.toggle()
                    }
                    
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

struct AccountView_Previews: PreviewProvider {
        
    static var previews: some View {
        AccountView(id: UUID(), accountName: "Amazon Prime", icon: "play.tv.fill", category: "Entertainment", email: "test@test.com", phone: "01234 098576", password: "TestPass1", address1: "1 Test Lane", address2: "Test Town", postcode: "LE16 9EL", price: 7.99, per: "month", paymentDay: "16th", paymentMonth: "March", isActive: true, showTabBar: .constant(false))
    }
}




