//
//  EditAccountView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct EditAccountView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var allAccounts: FetchedResults<AccountData>
    
    @AppStorage("defaultEmail") var defaultEmail = ""
    @AppStorage("defaultPhone") var defaultPhone = ""
    @AppStorage("defaultAddress1") var defaultAddress1 = ""
    @AppStorage("defaultAddress2") var defaultAddress2 = ""
    @AppStorage("defaultPostcode") var defaultPostcode = ""
    

    
    @Binding var showEditAccount: Bool
    
    @State var isEditing: Bool = false
    
    @State var id: UUID = UUID()
    @State var accountName: String = ""
    @State var icon: String = ""
    let isActive = true
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var address1: String = ""
    @State var address2: String = ""
    @State var postcode: String = ""
    @State var price: String = ""
    @State var actualPrice: Double = 0
    @State var per: String = ""
    @State var paymentDay: String = ""
    @State var paymentMonth: String = ""
    @State var selectedCategory: String = ""
    
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            // Header buttons
            HStack {
                Button {
                    showEditAccount = false
                } label: {
                    
                    Text("Cancel")
                        .foregroundColor(Color("PrimaryText"))
                }
                
                Spacer()
                
                Button {
                    
                    isEditing ? updateAccount(id: id, accounts: allAccounts) : saveAccount()
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(
                                LinearGradient(colors: [Color("Blue1"), Color("Blue2")], startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(width: 70, height: 40)
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                        
                        Text("Save")
                            .foregroundColor(.white)
                    }
                }
            }
            .font(.body.weight(.light))
            .foregroundColor(Color("Blue1"))
            .padding()
            
            
            VStack(spacing: 15) {
                
                // Account Name
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    TextField("Account Name", text: $accountName)
                        .padding(.leading, 10)
                        .disableAutocorrection(true)
                        .foregroundColor(Color("PrimaryText"))
                }
                
                // Account Icon
                
                VStack {
                    
                    Text("Select an Icon : ")
                        .foregroundColor(.secondary).opacity(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Constants.iconList, id: \.self) { i in
                                
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(colors: [Color("Blue1"), Color("Blue1"), Color("Blue2")], startPoint: .top, endPoint: .bottom)
                                        )
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 4, y: 4)
                                    
                                    Image(systemName: i)
                                        .foregroundColor(.white)
                                        .font(.title.weight(.thin))
                                    
                                }
                                .opacity((i == icon || icon == "") ? 1 : 0.5)
                                .animation(.easeInOut, value: icon)
                                .onTapGesture {
                                    icon = i
                                }
                                .frame(width: 55, height: 55)
                            }
                        }
                        .padding(.bottom)
                        
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.top)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                )
                
                // Category
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    HStack {
                        Text("Category:")
                            .font(.callout)
                            .opacity(0.6)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(Constants.categories, id: \.self) { category in
                                Text(category)
                            }
                            
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color("PrimaryText"))
                        .padding(.trailing, 10)

                    }
                    .padding(.horizontal, 10)
                }
                
                // Email
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    TextField("Email Address", text: $email)
                        .foregroundColor(Color("PrimaryText"))
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                        .disableAutocorrection(true)
                        .padding(.leading, 10)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding(.trailing, 10)
                    
                    if email == "" {
                    HStack {
                        Spacer()
                        
                        Button {
                            if defaultEmail != "" {
                                email = defaultEmail
                            } else {
                                alertTitle = "You have not set a default email address. You can set this in Settings"
                                showAlert.toggle()
                            }
                        } label: {
                            Text("Use Default")
                                .foregroundColor(Color("Green1"))
                                .font(.footnote)
                        }
                        .padding(.trailing, 10)
                    }
                }
                    
                }
                
                // Phone
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    TextField("Phone Number", text: $phone)
                        .padding(.leading, 10)
                        .foregroundColor(Color("PrimaryText"))
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                    
                    if phone == "" {
                    HStack {
                        Spacer()
                        
                        Button {
                            if defaultPhone != "" {
                                phone = defaultPhone
                            } else {
                                alertTitle = "You have not set a default phone number. You can set this in Settings"
                                showAlert.toggle()
                            }

                        } label: {
                            Text("Use Default")
                                .foregroundColor(Color("Green1"))
                                .font(.footnote)
                        }
                        .padding(.trailing, 10)
                    }
                }
                }
                
                // Password
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    TextField("Password", text: $password)
                        .padding(.leading, 10)
                        .foregroundColor(Color("PrimaryText"))
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                        .disableAutocorrection(true)
                    
                }
                
                // Registered Address
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 100)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                    
                    
                    VStack {
                        ZStack {
                            TextField("Address Line 1", text: $address1)
                                .padding(.leading, 10)
                                .foregroundColor(Color("PrimaryText"))
                                .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .disableAutocorrection(true)
                        
                            if address1 == "" && address2 == "" && postcode == "" {
                            HStack {
                                Spacer()
                                
                                Button {
                                    if defaultAddress1 != "" || defaultAddress2 != "" || defaultPostcode != "" {
                                        
                                        address1 = defaultAddress1
                                        address2 = defaultAddress2
                                        postcode = defaultPostcode
                                        
                                    } else {
                                        alertTitle = "You have not set a default address. You can set this in Settings"
                                        showAlert.toggle()
                                    }

                                } label: {
                                    Text("Use Default")
                                        .foregroundColor(Color("Green1"))
                                        .font(.footnote)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                            
                        }
                        
                        
                        TextField("Address Line 2", text: $address2)
                            .padding(.leading, 10)
                            .foregroundColor(Color("PrimaryText"))
                            .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .disableAutocorrection(true)
                        
                        TextField("Postcode", text: $postcode)
                            .padding(.leading, 10)
                            .foregroundColor(Color("PrimaryText"))
                            .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .disableAutocorrection(true)
                    }
                }
                
                // Price
                HStack {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(width: 100, height: 45)
                            .foregroundColor(Color("RowBackground"))
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                        
                        TextField("Price", text: $price)
                            .keyboardType(.decimalPad)
                            .padding(.leading, 10)
                            .foregroundColor(Color("PrimaryText"))
                            .frame(width: 100)
                        
                    }
                    
                    Spacer()
                    
                    Text("Per")
                        .foregroundColor(.secondary)
                    
                    
                    // Month
                    Button {
                        if price == "" {
                            alertTitle = "You must set the price first."
                            showAlert = true
                        } else {
                            if per == "month" {
                                per = ""
                                paymentDay = ""
                                paymentMonth = ""
                            } else {
                                per = "month"
                            }
                        }
                       
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: 80, height: 45)
                                .foregroundColor(Color("RowBackground"))
                                .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                            
                            if per == "month" {
                                Text("Month")
                                    .foregroundColor(Color("PrimaryText"))
                                    .bold()
                            } else {
                                Text("Month")
                                    .fontWeight(.light)
                            }
                        }
                    }
                    .foregroundColor(.gray.opacity(0.7))
                    
                    // Year
                    Button {
                        if price == "" {
                            alertTitle = "You must set the price first."
                            showAlert = true
                        } else {
                            if per == "year" {
                                per = ""
                                paymentDay = ""
                                paymentMonth = ""
                            } else {
                                per = "year"
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: 80, height: 45)
                                .foregroundColor(Color("RowBackground"))
                                .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                            
                            if per == "year" {
                                Text("Year")
                                    .foregroundColor(Color("PrimaryText"))
                                    .bold()
                            } else {
                                Text("Year")
                                    .fontWeight(.light)
                            }
                        }
                    }
                    .foregroundColor(.gray.opacity(0.7))
                }
                
                // Payment Date
                
                VStack (spacing: 10){
                    
                    if per == "month" || per == "year" {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(height: 45)
                                .foregroundColor(Color("RowBackground"))
                                .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                            
                            HStack {
                                
                                Text("Payment Date:")
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .foregroundColor(Color("PrimaryText"))
                                
                                Spacer()
                                
                                Picker("Date", selection: $paymentDay) {
                                    ForEach(Constants.datesList.reversed(), id: \.self) { date in
                                        Text(date)
                                    }
                                    
                                }
                                .pickerStyle(.menu)
                                .accentColor(Color("PrimaryText"))
                                .padding(.trailing, 10)
                                
                                
                            }
                            .padding(.horizontal, 10)
                    }
                    }
                    
                    // Payment Month
                    if per == "year" {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(height: 45)
                                .foregroundColor(Color("RowBackground"))
                                .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                            
                            HStack {
                                Text("Payment Month:")
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .foregroundColor(Color("PrimaryText"))
                                
                                Spacer()
                                
                                Picker("Month", selection: $paymentMonth) {
                                    ForEach(Constants.monthsList.reversed(), id: \.self) { month in
                                        Text(month)
                                    }
                                    
                                }
                                .pickerStyle(.menu)
                                .accentColor(Color("PrimaryText"))
                                .padding(.trailing, 10)

                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    
            }
                
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 40)
                
                
                
                
            }
            .padding(5)
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
        .padding()
        .background(Color("Background"))
        
        
    }
    
    func saveAccount() {
        
        if !price.isEmpty {
            actualPrice = Double(price) ?? 0
        }
        
        if accountName.isEmpty || icon.isEmpty {
            // Show alert
            alertTitle = "Account name and Icon must be set."
            showAlert = true
            
        }
        else if !price.isEmpty && per.isEmpty {
            alertTitle = "You must set the payment frequency."
            showAlert = true
            }

        else if per == "year" && paymentMonth.isEmpty {
            alertTitle = "You must set the payment month."
            showAlert = true
        }
        else {
            
            let newAccount = AccountData(context: moc)
            
            newAccount.id = UUID()
            newAccount.name = accountName
            newAccount.isActive = true
            newAccount.icon = icon
            newAccount.category = selectedCategory
            newAccount.email = email
            newAccount.phone = phone
            newAccount.password = password
            newAccount.address1 = address1
            newAccount.address2 = address2
            newAccount.postcode = postcode
            newAccount.price = actualPrice
            newAccount.per = per
            newAccount.paymentDay = paymentDay
            newAccount.paymentMonth = paymentMonth
            
            do {
                try moc.save()
                showEditAccount = false
                
            } catch let error {
                alertTitle = "Could not create an account \(error.localizedDescription)"
                showAlert.toggle()
            }
            
        }
    }
    
    func updateAccount(id: UUID, accounts: FetchedResults<AccountData>) {
        
        if !price.isEmpty {
            actualPrice = Double(price) ?? 0
        }
//        else {
//            actualPrice = Double(price) ?? 0
//        }
        
        if accountName.isEmpty || icon.isEmpty {
            // Show alert
            alertTitle = "Account name and Icon must be set."
            showAlert = true
            
        }
        else if !price.isEmpty && per.isEmpty {
            alertTitle = "You must set the payment frequency."
            showAlert = true
            }

        else if per == "year" && paymentMonth.isEmpty {
            alertTitle = "You must set the payment month."
            showAlert = true
        }
        
        else {
            for account in accounts {
                if account.id == id {
                    account.name = accountName
                    account.icon = icon
                    account.category = selectedCategory
                    account.email = email
                    account.phone = phone
                    account.password = password
                    account.address1 = address1
                    account.address2 = address2
                    account.postcode = postcode
                    account.price = actualPrice
                    account.per = per
                    account.paymentDay = paymentDay
                    account.paymentMonth = paymentMonth
                }
            }
        }
        do {
            try moc.save()
            showEditAccount = false
        } catch {
            print("Error updating Account \(error.localizedDescription)")
        }
    }
    
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView(showEditAccount: .constant(true))
    }
}

