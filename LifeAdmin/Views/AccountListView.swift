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
    
    @EnvironmentObject var filterVM: FilterViewModel
    @EnvironmentObject var controlVM: ControlViewModel
    @EnvironmentObject var spotlight: SpotlightVM
    
    @AppStorage("showTotalAs") var showTotalAs = "month"
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ]) var allAccounts: FetchedResults<AccountData>
    
    
    @State private var totalPrice: Double = 0
    
    @State private var showDelete = false
    @State var selectedID: UUID = UUID()
            
    let keychain = Keychain(service: "AaronArcher.LifeAdmin").synchronizable(true)

    
    var body: some View {
        
        
      
        NavigationView {
            VStack {
                    
                    ZStack(alignment: .top) {
                        
                        HeaderView(text: filterVM.showActive ? "Active Accounts" : "Inactive Accounts")
                        
                        HStack {
                            
                            Button {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        controlVM.animateBG.toggle()
                                    }
                                    withAnimation(.spring()) {
                                        controlVM.showCategories.toggle()
                                    }
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.4, blendDuration: 0.3).delay(0.2)) {
                                        controlVM.animatePath.toggle()
                                    }
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
                                controlVM.showSettings = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .dynamicTypeSize(.medium)
                                    .accessibilityLabel("Settings")

                            }
                            
                        }
                        .padding(.horizontal)
                        .offset(y: (Constants.screenHeight / 6) / 2.5)
                        
                    }
                    
                    //MARK: Total
                    
                    HStack {
                        
                        if filterVM.selectedCategory != "None" {
                            
                            VStack(alignment: .leading) {
                                
                                Text("Filtered by:")
                                    .foregroundColor(Color("Green1"))
                                
                                Text(filterVM.selectedCategory)
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
                        .frame(width: Constants.screenWidth / 1.1, height: Constants.screenHeight / 3)
                        .spotlight(enabled: spotlight.currentSpotlight == 4, title: "View all of your accounts here.\nSelect an account to view/edit your account information or swipe to delete an account.")
                    
                        
                        
                        //MARK: List of Accounts
                        FilteredAccountsView(predicate: filterVM.predicate, showTotalAs: $showTotalAs, showDelete: $showDelete, selectedID: $selectedID, totalPrice: $totalPrice)
                        
                    
                        
                    }
              
                    
                    Spacer()
                }
          
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(Color("Background"))
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear(perform: {
                if !controlVM.showTabBar {
                    withAnimation(.spring()) {
                        controlVM.showTabBar = true
                    }
                }
                
            })
            .alert("Are you sure you want to delete this account?", isPresented: $showDelete, actions: {
                Button("OK") { deleteAccount(id: selectedID, accounts: allAccounts) }
                Button("Cancel", role: .cancel) { }
            })
            .fullScreenCover(isPresented: $controlVM.showNewAccount, onDismiss: {
                DispatchQueue.main.async {
                    filterVM.refreshTotal.toggle()
                }
            }) {
                EditAccountView(showEditAccount: $controlVM.showNewAccount)
            }
            .fullScreenCover(isPresented: $controlVM.showSettings) {
                SettingsView()
        }
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
        DispatchQueue.main.async {
            filterVM.refreshTotal.toggle()
        }
    }
    
}



struct ActiveView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView()
    }
}

struct FlatButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
