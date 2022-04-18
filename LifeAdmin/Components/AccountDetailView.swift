//
//  AccountDetailView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI
import LocalAuthentication


struct AccountDetailField: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    
    var id: UUID?
    var title: String = ""
    var text: String = ""
    var fieldWidth: CGFloat = .infinity
    var fieldHeight: CGFloat = 45
    var isPrice: Bool = false
    var price: Double = 0.0
    var per: String = "/month"
    
    var body: some View {
        
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Constants.isScreenLarge ? .footnote.weight(.light) : .caption.weight(.light))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.leading, 10)
                    .lineLimit(1)
                
                Group {
                    
                    if isPrice {
                        if price != 0 {

                            Group {
                                Text("£\(price,specifier: "%.2f")")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color("PrimaryText"))

                                + Text("/\(per)")
                                    .font(.caption.weight(.light))
                                    .foregroundColor(Color("PrimaryText"))

                            }
                            .padding(10)

                        } else {
                            Text("-")
                                .foregroundColor(.gray.opacity(0.7))
                                .font(.title3)
                                .padding(10)

                        }
                        
                    } else {
                        if text != "" && text != "\n\n" {
                            Text(verbatim: text)
                                .foregroundColor(Color("PrimaryText"))
                                .font(.title3)
                                .padding(10)
                                .lineLimit(title == "Address" ? 3 : 1)

                        } else {
                            Text("-")
                                .foregroundColor(.gray.opacity(0.7))
                                .font(.title3)
                                .padding(10)
                                .lineLimit(1)

                        }
                    }

                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(minHeight: 45)
                        .foregroundColor(Color("RowBackground"))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 2, y: 2)
                )
                
            }
    
    
    }
        
}


