//
//  AccountRow.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

struct AccountRow: View {
        
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ], predicate: NSPredicate(format: "isActive == true")) var activeAccounts: FetchedResults<AccountData>
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
    ], predicate: NSPredicate(format: "isActive == false")) var inactiveAccounts: FetchedResults<AccountData>
            
    var isActive: Bool = true
    @State private var showAccount = false
    @State private var showBackground = false
    
    var name: String = "Amazon Prime"
    var icon: String = "play.tv.fill"
    var price: Double = 6.99
    var per: String = ""
    var id: UUID
    @Binding var selectedID: UUID
    @Binding var showDelete: Bool
    
    // Offset for gesture
    @GestureState var gestureOffset: CGFloat = 0
    @State var offset: CGFloat = 0
    
    // Last stored offset
    @State var lastStoredOffset: CGFloat = 0
    
    var body: some View {
        
        ZStack {

            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(isActive ? Color("RowBackground") : Color("Gray2"))
                .shadow(color: .black.opacity(0.15), radius: 5, x: 2, y: 3)
                .frame(height: 60)
            
            HStack {
                
                //MARK: Icon
                ZStack {
                    
                    if isActive {
                        Circle()
                            .fill(
                                LinearGradient(colors: [Color("Blue1"), Color("Blue1"), Color("Blue2")], startPoint: .top, endPoint: .bottom)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 4, y: 4)
                    } else {
                        Circle()
                            .fill(Color("Gray1"))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 4, y: 4)

                    }
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.title.weight(.thin))
                }
                .frame(width: 65, height: 65)
                .offset(x: -25)

                
                Text(name)
                    .font(.title3)
                    .lineLimit(1)
                   
                
                Spacer()
                
                if price != 0.0 {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("£\(price, specifier: "%.2f")")
                            .font(.subheadline.weight(.light))
    
                       Text("/\(per)")
                            .font(.caption.weight(.light))
                            .foregroundColor(Color("Green1"))
                    }
                }
                
                
            }
            .padding(.trailing)
            .foregroundColor(Color("PrimaryText"))
            

        }
        .padding(.leading, 30)
        .offset(x: offset)
        .background(
        
            ZStack (alignment: .trailing) {
                Color(isActive ? "Green1" : "Gray1")
                
                Button {
                    selectedID = id
                    Constants.deleteHaptic()
                    showDelete = true
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.title.weight(.light))
                        .foregroundColor(.white)
                    .padding(.trailing, 15)
                }
            
            }
                .frame(height: 60)
                .cornerRadius(15)
                .padding(1)
                .padding(.leading, 20)
                .opacity(showBackground ? 1 : 0)
        )
        .gesture(
        
            DragGesture()
                .updating($gestureOffset, body: { value, out, _ in
                    
                    out = value.translation.width
                })
                .onEnded({ value in
                    
                    let translation = value.translation.width
                    
                    if translation < 0 && -translation > 60 && -translation < 150 {
                        offset = -60
                    } else if -translation > 150 {
                        offset = -60
                        selectedID = id
                        Constants.deleteHaptic()
                        showDelete = true
                    } else {
                        offset = 0
                    }
                    
                    lastStoredOffset = offset
                })
        )
        .animation(.spring(), value: gestureOffset == 0)
        // Updating offset
        .onChange(of: gestureOffset) { newValue in
            offset = (gestureOffset + lastStoredOffset) > 0 ? 0 : (gestureOffset + lastStoredOffset)
        }
//        .opacity(showAccount ? 1 : 0)
        .onAppear {
            // Show accounts one at a time
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
//                withAnimation(.easeInOut(duration: 0.2).delay(Double(isActive ? getActiveIndex() : getInactiveIndex()) * 0.0)) {
//                    showAccount = true
//                }
//            }

            // Stop Background flashing first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2).delay(Double(isActive ? getActiveIndex() : getInactiveIndex()) * 0.0)) {
                    showBackground = true
                }
            }

            // reset offset when going back to the account list view
            offset = 0
        }
    
    }
    
    func getActiveIndex() -> Int {
        return activeAccounts.firstIndex { currentAccount in
            return id == currentAccount.id
        } ?? 0
    }
    
    func getInactiveIndex() -> Int {
        return inactiveAccounts.firstIndex { currentAccount in
            return id == currentAccount.id
        } ?? 0
    }

    
}

struct AccountRow_Previews: PreviewProvider {
    
    static var previews: some View {
        AccountRow(id: UUID(), selectedID: .constant(UUID()), showDelete: .constant(false))
    }
}

