//
//  CategoriesView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 03/04/2022.
//

import SwiftUI


struct CategoriesView: View {
    
    
    @Binding var selectedCategory: String
    @State private var newCategory = ""
    
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
                .padding(.bottom)
                
                Text("Filter your accounts by:")
                    .font(.title3.weight(.light))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.bottom, 40)

                // Categories
                
//                Button {
//                    withAnimation() {
//                        selectedCategory = "None"
//                    }
//                } label: {
//
//                    ZStack {
//                        if selectedCategory == "None" {
//                            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                .frame(height: 40)
//                                .foregroundColor(Color("Green1"))
//                                .matchedGeometryEffect(id: "category", in: namespace)
//
//                            Text("All")
//                                .foregroundColor(selectedCategory == "None" ? .white : Color("PrimaryText"))
//                                .font(.title3)
//
//                        } else {
//                            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                .frame(height: 40)
//                                .foregroundColor(.clear)
//
//
//                        }
//                        Text("All")
//                            .foregroundColor(selectedCategory == "None" ? .white : Color("PrimaryText"))
//                            .font(.title3)
//
//                    }
//                }
//                .buttonStyle(FlatButtonStyle())
//                .font(.title3.weight(.light))
                
                ForEach(Constants.categories.sorted(), id: \.self) { category in
                    if category != "None" {
                        Button {
                            withAnimation {
                                newCategory = category
                            }
                        } label: {
                            
                            ZStack {
                                if newCategory == category {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .frame(height: 40)
                                        .foregroundColor(Color("Green1"))
                                        .matchedGeometryEffect(id: "category", in: namespace)
                                    
                                    Text(category)
                                        .foregroundColor(newCategory == category ? .white : Color("PrimaryText"))
                                        .font(.title3)
                                    
                                } else {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .frame(height: 40)
                                        .foregroundColor(.clear)
                                    
                                    
                                }
                                Text(category)
                                    .foregroundColor(newCategory == category ? .white : Color("PrimaryText"))
                                    .font(.title3)
                                    
                            }
                        }
                        .buttonStyle(FlatButtonStyle())
                        .font(.title3.weight(.light))
                    }
                    
                    
                }
                
                Spacer()
                
                HStack {
                    
                    Button {
                        
                        selectedCategory = "None"
                        newCategory = ""
                        withAnimation {
                            showCategories.toggle()
                        }
                        
                    } label: {
                        Text("Clear filter")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(Color("Green1"))
                            )
                    }
                    .disabled(newCategory == "")
                    .opacity(newCategory == "" ? 0.7 : 1)
                    
                    Spacer()
                    
                    Button {
                        
                        selectedCategory = newCategory
                        withAnimation {
                            showCategories.toggle()
                        }
                        
                    } label: {
                        Text("Apply filter")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(Color("Green1"))
                            )
                    }
                    .opacity((selectedCategory == newCategory) || (newCategory == "") ? 0.7 : 1)
                    .disabled((selectedCategory == newCategory) || (newCategory == ""))
                    
                
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
        CategoriesView(selectedCategory: .constant("All"), showCategories: .constant(true))
    }
}
