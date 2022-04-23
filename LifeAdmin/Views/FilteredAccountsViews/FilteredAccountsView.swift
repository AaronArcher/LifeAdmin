//
//  FilteredAccountsView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 21/04/2022.
//

import SwiftUI
import CoreData

struct FilteredAccountsView: View {
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var predicateFilter: PredicateFilter
    
    @FetchRequest var filteredAccounts: FetchedResults<AccountData>
    
    init(predicate: NSPredicate?, showTotalAs: Binding<String>, showActive: Binding<Bool>, showDelete: Binding<Bool>, selectedID: Binding<UUID>, totalPrice: Binding<Double>, showTabBar: Binding<Bool>) {
        let request: NSFetchRequest<AccountData> = AccountData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AccountData.name, ascending: true)]
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        _filteredAccounts = FetchRequest<AccountData>(fetchRequest: request)
        _showTotalAs = showTotalAs
        _showActive = showActive
        _showDelete = showDelete
        _selectedID = selectedID
        _totalPrice = totalPrice
        _showTabBar = showTabBar
        
    }
    
    @Binding var showTotalAs: String
    @Binding var showActive: Bool
    @Binding var showDelete: Bool
    @Binding var selectedID: UUID
    @Binding var totalPrice: Double
    @Binding var showTabBar: Bool
    

    var body: some View {
        
        if predicateFilter.showActive && filteredAccounts.count == 0 {
            
            Text("You do not have any active accounts...")
                .foregroundColor(Color("PrimaryText"))
                .font(.title3.weight(.light))
                .frame(width: Constants.screenWidth / 1.5)
                .multilineTextAlignment(.center)
                .padding(.top)
                .onAppear {
                    calcTotal()
                }
            
        } else if !predicateFilter.showActive && filteredAccounts.count == 0 {
            Text("You do not have any inactive accounts...")
                .foregroundColor(Color("PrimaryText"))
                .font(.title3.weight(.light))
                .frame(width: Constants.screenWidth / 1.5)
                .multilineTextAlignment(.center)
                .padding(.top)
                .onAppear {
                    calcTotal()
                }
            
        } else {
            
        GeometryReader { geo in
            ZStack {
                ScrollView(showsIndicators: false) {
                    
                    ForEach(filteredAccounts) { account in
                        
                        NavigationLink {

                            AccountView(
                                id: account.id ?? UUID(),
                                accountName: account.name ?? "",
                                icon: account.icon ?? "",
                                category: account.category ?? "",
                                email: account.email ?? "",
                                phone: account.phone ?? "",
                                address1: account.address1 ?? "",
                                address2: account.address2 ?? "",
                                postcode: account.postcode ?? "",
                                price: account.price,
                                per: account.per ?? "",
                                paymentDay: account.paymentDay ?? "",
                                paymentMonth: account.paymentMonth ?? "",
                                isActive: account.isActive,
                                showTabBar: $showTabBar)

                        } label: {
                            AccountRow(isActive: account.isActive, name: account.name ?? "Test", icon: account.icon ?? "plus", price: account.price, per: account.per ?? "", id: account.id ?? UUID(), selectedID: $selectedID, showDelete: $showDelete)

                        }
                        .padding(.bottom, account == filteredAccounts.last ? 90 : 0)
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
            .frame(height: Constants.screenHeight / 1.7)
            
        }
    
        .onAppear {
            calcTotal()
        }
        .onChange(of: predicateFilter.selectedCategoy, perform: { _ in
            print("OnChange Category")
            calcTotal()
        })
        .onChange(of: predicateFilter.showActive, perform: { _ in
            print("onChange Active\(predicateFilter.showActive)")
            calcTotal()
        })
        .onChange(of: showTotalAs, perform: { _ in
            calcTotal()
        })
            
            }
        
    }
    
    func calcTotal() {
        if showTotalAs == "month" {
            var total: Double = 0
//            let accounts = isActive ? activeAccounts : inactiveAccounts
            for account in filteredAccounts {
                if account.per == "year" {
                    total += account.price / 12
                }
                else {
                    total += account.price
                }
            }
            DispatchQueue.main.async {
                totalPrice = total
            }
            print("New all calc total performed against month total:\(totalPrice)")
            
        } else {
            var total: Double = 0
//            let accounts = isActive ? activeAccounts : inactiveAccounts
            for account in filteredAccounts {
                if account.per == "month" {
                    total += account.price * 12
                }
                else {
                    total += account.price
                }
            }
            DispatchQueue.main.async {
                totalPrice = total
            }
            print("New all calc total performed against year")
        }
    }

    
}
