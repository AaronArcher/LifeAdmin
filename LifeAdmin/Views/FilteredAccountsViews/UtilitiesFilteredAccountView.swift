//
//  UtilitiesFilteredAccountView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 05/04/2022.
//

import SwiftUI

struct UtilitiesFilteredAccountView: View {
 
    @Environment(\.managedObjectContext) var moc
    
    @Binding var showTotalAs: String
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ], predicate: FilterPredicates.activeUtilitiesPredicate) var activeAccounts: FetchedResults<AccountData>

    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ], predicate: FilterPredicates.inactiveUtilitiesPredicate) var inactiveAccounts: FetchedResults<AccountData>
    
    @Binding var showActive: Bool
    @Binding var showDelete: Bool
    @Binding var selectedID: UUID
    @Binding var totalPrice: Double
    @Binding var showTabBar: Bool


    var body: some View {
        
        if showActive && activeAccounts.count == 0 {
            
            Text("You do not have any active accounts in this category...")
                .foregroundColor(Color("PrimaryText"))
                .font(.title3.weight(.light))
                .frame(width: Constants.screenWidth / 1.5)
                .multilineTextAlignment(.center)
                .padding(.top).onAppear {
                    calcTotal(showActive)
                }

            
        } else if !showActive && inactiveAccounts.count == 0 {
            Text("You do not have any inactive accounts in this category...")
                .foregroundColor(Color("PrimaryText"))
                .font(.title3.weight(.light))
                .frame(width: Constants.screenWidth / 1.5)
                .multilineTextAlignment(.center)
                .padding(.top)
                .onAppear {
                    calcTotal(showActive)
                }

            
        } else {
            
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
            .frame(height: Constants.screenHeight / 1.7)
            
        }
    
        .onAppear {
            calcTotal(showActive)
        }
        .onChange(of: showActive, perform: { _ in
            calcTotal(showActive)
        })
        .onChange(of: showTotalAs, perform: { _ in
            calcTotal(showActive)
            
        })
        
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

    
}

struct UtilitiesFilteredAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UtilitiesFilteredAccountView(showTotalAs: .constant(""), showActive: .constant(true), showDelete: .constant(false), selectedID: .constant(UUID()), totalPrice: .constant(0), showTabBar: .constant(false))
    }
}
