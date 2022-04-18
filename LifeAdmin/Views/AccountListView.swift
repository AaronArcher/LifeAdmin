//
//  AccountListView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI
import KeychainAccess

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
    @Binding var animatePath: Bool
    @Binding var animateBG: Bool
    
    @Binding var showSave: Bool
    
    @Binding var showTabBar: Bool
    
    @EnvironmentObject var spotlight: SpotlightVM

    
    let keychain = Keychain(service: "AaronArcher.LifeAdmin").synchronizable(true)

    
    var body: some View {
        
        
      
        NavigationView {
            VStack {
                    
                    ZStack(alignment: .top) {
                        
                        HeaderView(text: showActive ? "Active Accounts" : "Inactive Accounts")
                        
                        HStack {
                            
                            Button {
                                withAnimation {
                                    animateBG.toggle()
                                }
                                withAnimation(.spring()) {
                                    showCategories.toggle()
                                }
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.4, blendDuration: 0.3).delay(0.2)) {
                                    animatePath.toggle()
                                }
                                
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .dynamicTypeSize(.medium)
                                    .accessibilityLabel("Category filter")
                            }
                            .spotlight(enabled: spotlight.currentSpotlight == 5, title: "Filter your accounts by category using this button.")
                            
                            
                            Spacer()
                            
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .dynamicTypeSize(.medium)
                                    .accessibilityLabel("Settings")

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
                        .spotlight(enabled: spotlight.currentSpotlight == 3, title: "Your total expenditure is shown here, you can toggle this between monthly or yearly in the settings page.")
                        
                    }
                    .padding(.trailing, 8)
                    .padding()
                    
                
                ZStack(alignment: .top) {
                
                    Rectangle()
                        .fill(.clear)
                        .frame(width: screen.width / 1.1, height: screen.height / 3)
                        .spotlight(enabled: spotlight.currentSpotlight == 4, title: "View all of your accounts here.\nSelect an account to view/edit your account information or swipe to delete an account.")
                    
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
                        
                        
                        // List of Accounts
                        
                        switch selectedCategory {
                            
                        case "Education":
                            EducationFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Entertainment":
                            EntertainmentFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Finance":
                            FinanceFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Health":
                            HealthFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Other":
                            OtherFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Social Media":
                            SocialMediaFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Travel":
                            TravelFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        case "Utilities":
                            UtilitiesFilteredAccountView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                            
                        default:
                            AllAccountsView(showTotalAs: $showTotalAs, showActive: $showActive, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice, showTabBar: $showTabBar)
                                                
                        
                        }
                        
                    }
                        
                    }
              
                    
                    Spacer()
                }
          
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(Color("Background"))
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear(perform: {
                withAnimation(.spring()) {
                    showTabBar = true
                }
            })
            .alert("Are you sure you want to delete this account?", isPresented: $showDelete, actions: {
                Button("OK") { deleteAccount(id: selectedID, accounts: allAccounts) }
                Button("Cancel", role: .cancel) { }
            })
            .fullScreenCover(isPresented: $showNewAccount, onDismiss: {
                calcTotal(showActive)
            }) {
                EditAccountView(showEditAccount: $showNewAccount, showSave: $showSave)
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsView()
        }
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
            print(" all calc total performed against month")


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
            print(" all calc total performed against year")

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
            
            do {
                try keychain.remove("\(id)")
            } catch let error {
                print("error: \(error)")
            }

                    } catch {
            // handle the Core Data error
            print("Error saving CoreData after delete")
        }
        calcTotal(showActive)
        
    }
    
}



struct ActiveView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView(showNewAccount: .constant(false), showActive: .constant(true), selectedID: UUID(), showSettings: .constant(false), showCategories: .constant(false), selectedCategory: .constant("Entertainment"), animatePath: .constant(false), animateBG: .constant(false), showSave: .constant(false), showTabBar: .constant(true))
    }
}

struct FlatButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
