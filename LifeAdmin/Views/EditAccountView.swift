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
    
    let iconList: [String] = ["play.tv.fill", "phone.fill", "flame.fill", "bolt.fill", "gamecontroller.fill", "book.fill", "desktopcomputer", "computermouse.fill", "heart.fill", "bag.fill", "drop.fill", "envelope.fill", "star.fill", "music.note", "moon.fill", "house.fill", "brain.head.profile", "cross.fill", "waveform.path.ecg", "sterlingsign.circle.fill", "pawprint.fill", "leaf.fill", "airplane", "car.fill", "train.side.front.car", "network", "wifi", "mic.fill"]
    
    let dates: [String] = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th","13th", "14th", "15th", "16th","17th", "18th", "19th", "20th", "21st", "22nd", "23rd", "24th", "25th", "26th", "27th", "28th", "29th", "30th", "31st", "Select"]
    
    let months: [String] = ["Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec", "Select"]
    
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
                            ForEach(iconList, id: \.self) { i in
                                
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
                        .keyboardType(.namePhonePad)
                        .textContentType(.telephoneNumber)
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
                        TextField("Address Line 1", text: $address1)
                            .padding(.leading, 10)
                            .foregroundColor(Color("PrimaryText"))
                            .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .disableAutocorrection(true)
                        
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
                        if per == "month" {
                            per = ""
                        } else {
                            per = "month"
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
                        if per == "year" {
                            per = ""
                        } else {
                            per = "year"
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
                                    ForEach(dates.reversed(), id: \.self) { date in
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
                                    ForEach(months.reversed(), id: \.self) { month in
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
            
        } else if !price.isEmpty && per.isEmpty {
            alertTitle = "You must set the payment date."
            showAlert = true
            
        } else if (price.isEmpty || actualPrice == 0) && !per.isEmpty {
            alertTitle = "You must set the price."
            showAlert = true
        }
        else {
            
            let newAccount = AccountData(context: moc)
            
            newAccount.id = UUID()
            newAccount.name = accountName
            newAccount.isActive = true
            newAccount.icon = icon
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
        } else {
            actualPrice = Double(price) ?? 0
        }
        
        if !price.isEmpty && per.isEmpty {
            alertTitle = "You must set the payment date."
            showAlert = true
            
        } else if (price.isEmpty || actualPrice == 0) && !per.isEmpty {
            alertTitle = "You must set the price."
            showAlert = true
        } else {
            for account in accounts {
                if account.id == id {
                    account.name = accountName
                    account.icon = icon
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

