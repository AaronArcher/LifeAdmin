//
//  CategoriesView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 03/04/2022.
//

import SwiftUI

struct CategoriesView: View {
    
    @State private var categories: [String] = ["All", "Bills", "Education", "Finance", "Entertainment", "Social Media", "Travel", "Other"].sorted()
    
    @State var selectedCategory = "All"
    
    let screenWidth = UIScreen.main.bounds.width
    @Binding var showCategories: Bool
    
    @Namespace var namespace
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {

                // Header
                HStack {

                    Button {
                        withAnimation {
                            showCategories.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("PrimaryText"))
                            .font(.title2.weight(.light))
                            .frame(width: 30, height: 30)
                    }

                    Spacer()

                    Text("Categories")
                        .font(.title.weight(.light))
                        .foregroundColor(Color("Green1"))

                    Spacer()

                    Color.clear
                        .frame(width: 30, height: 30)
                }
                .padding(.bottom, 30)

                // Categories
                ForEach(categories, id: \.self) { category in
                    
                    Button {
                        withAnimation {
                            selectedCategory = category
                        }
                    } label: {
                        ZStack {
                            if selectedCategory == category {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .frame(height: 40)
                                    .foregroundColor(Color("Green1"))
                                    .matchedGeometryEffect(id: "category", in: namespace)
                            }
                            Text(category)
                                .foregroundColor(selectedCategory == category ? .white : Color("PrimaryText"))
                                .font(selectedCategory == category ? .title3 : .title3.weight(.light))
                                .matchedGeometryEffect(id: "text\(category)", in: namespace)
                               
                        }
                    }
                    .padding(5)
                    .font(.title3.weight(.light))
                    
                       
                }
              

                Spacer()
            }
            .padding()
            .padding(.top,5)

            Spacer()
            
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color("Green1"))
                .ignoresSafeArea()
           
        }
        .frame(width: screenWidth - 100, alignment: .leading)
        .background(Color("Background"))
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity, alignment: .leading)
        

    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(showCategories: .constant(true))
    }
}
