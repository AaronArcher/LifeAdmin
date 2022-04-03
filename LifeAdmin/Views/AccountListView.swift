//
//  AccountListView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct AccountListView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @AppStorage("showTotalAs") var showTotalAs = "month"
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ]) var allAccounts: FetchedResults<AccountData>
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ], predicate: NSPredicate(format: "isActive == true")) var activeAccounts: FetchedResults<AccountData>
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ], predicate: NSPredicate(format: "isActive == false")) var inactiveAccounts: FetchedResults<AccountData>
    
    
    @Binding var showNewAccount: Bool
    
    @Binding var showActive: Bool
    
    let screen = UIScreen.main.bounds
    
    @State private var totalPrice: Double = 0
    
    @State private var showDelete = false
    @State var selectedID: UUID = UUID()
    @Binding var showSettings: Bool
    @Binding var showCategories: Bool
    @Binding var selectedCategory: String
    
    
    var body: some View {
        
        
        VStack {
            
            ZStack(alignment: .top) {
                
                HeaderView(text: showActive ? "Active Accounts" : "Inactive Accounts")
                
                HStack {
                    
                    Button {
                        withAnimation {
                            showCategories.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    
                }
                .padding(.horizontal)
                .offset(y: (screen.height / 6) / 2.5)
                
            }
            
            // Total
            
            HStack {
                
                if selectedCategory != "None" {
                    
                    VStack(alignment: .leading) {
                        
                        Text("Filtered by:")
                            .foregroundColor(Color("Green1"))
                        
                        Text(selectedCategory)
                            .font(.title3.bold())
                            .foregroundColor(Color("PrimaryText"))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    Text("Total")
                        .foregroundColor(Color("Green1"))
                    
                    HStack(spacing: 3) {
                        Text("£\(totalPrice, specifier: "%.2f")")
                            .font(.title3.bold())
                        Text("/\(showTotalAs)")
                            .font(.caption)
                    }
                    .foregroundColor(Color("PrimaryText"))
                    
                    
                }
            }
            .padding(.trailing, 8)
            .padding()
            
            
            if showActive && activeAccounts.count == 0 {
                
                Text("You haven't created any accounts yet...")
                    .foregroundColor(Color("PrimaryText"))
                    .font(.title3.weight(.light))
                    .frame(width: screen.width / 1.5)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
            } else if !showActive && inactiveAccounts.count == 0 {
                Text("You do not have any inactive accounts...")
                    .foregroundColor(Color("PrimaryText"))
                    .font(.title3.weight(.light))
                    .frame(width: screen.width / 1.5)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
            } else {
                
                //Accounts
                GeometryReader { geo in
                    ZStack {
                        ScrollView(showsIndicators: false) {
                            
                            ForEach(showActive ? activeAccounts : inactiveAccounts) { account in
                                
                                NavigationLink {
                                    
                                    AccountView(
                                        id: account.id ?? UUID(),
                                        accountName: account.name ?? "",
                                        icon: account.icon ?? "",
                                        category: account.category ?? "",
                                        email: account.email ?? "",
                                        phone: account.phone ?? "",
                                        password: account.password ?? "",
                                        address1: account.address1 ?? "",
                                        address2: account.address2 ?? "",
                                        postcode: account.postcode ?? "",
                                        price: account.price,
                                        per: account.per ?? "",
                                        paymentDay: account.paymentDay ?? "",
                                        paymentMonth: account.paymentMonth ?? "",
                                        isActive: account.isActive)
                                    
                                } label: {
                                    AccountRow(isActive: account.isActive, name: account.name ?? "Test", icon: account.icon ?? "plus", price: account.price, per: account.per ?? "", id: account.id ?? UUID(), selectedID: $selectedID, showDelete: $showDelete)
                                    
                                }
                                .padding(.bottom, account == activeAccounts.last ? 90 : 0)
                                .padding(.trailing, 8)
                                .buttonStyle(FlatButtonStyle())
                                
                            }
                            
                        }
                        
                        Rectangle()
                            .fill(
                                LinearGradient(colors: [Color("Background").opacity(0.0),
                                                        Color("Background").opacity(0.5),
                                                        Color("Background")], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(height: 0.4 * geo.size.height)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .allowsHitTesting(false)
                        
                    }
                    .padding(.horizontal)
                    .frame(height: screen.height / 1.7)
                    
                }
                
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            calcTotal(showActive)
        }
        .onChange(of: showActive, perform: { _ in
            calcTotal(showActive)
        })
        .onChange(of: showTotalAs, perform: { _ in
            calcTotal(showActive)
        })
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .alert("Are you sure you want to delete this account?", isPresented: $showDelete, actions: {
            Button("OK") { deleteAccount(id: selectedID, accounts: allAccounts) }
            Button("Cancel", role: .cancel) { }
        })
        .sheet(isPresented: $showNewAccount, onDismiss: {
            calcTotal(showActive)
        }) {
            EditAccountView(showEditAccount: $showNewAccount)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        
        
    }
    
    func calcTotal(_ isActive: Bool) {
        if showTotalAs == "month" {
            var total: Double = 0
            let accounts = isActive ? activeAccounts : inactiveAccounts
            for active in accounts {
                if active.per == "year" {
                    total += active.price / 12
                }
                else {
                    total += active.price
                }
            }
            totalPrice = total
            
        } else {
            var total: Double = 0
            let accounts = isActive ? activeAccounts : inactiveAccounts
            for active in accounts {
                if active.per == "month" {
                    total += active.price * 12
                }
                else {
                    total += active.price
                }
            }
            totalPrice = total
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
        calcTotal(showActive)
        
    }
    
}



struct ActiveView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView(showNewAccount: .constant(false), showActive: .constant(true), selectedID: UUID(), showSettings: .constant(false), showCategories: .constant(false), selectedCategory: .constant("Entertainment"))
    }
}

struct FlatButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
