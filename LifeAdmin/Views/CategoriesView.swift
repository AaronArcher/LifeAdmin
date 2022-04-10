//
//  CategoriesView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 10/04/2022.
//

import SwiftUI

struct CategoriesView: View {
    
    @Binding var selectedCategory: String
    @State private var newCategory = ""
    
    @Binding var showCategories: Bool
    let screenWidth = UIScreen.main.bounds.width
    
    var isScreenLarge: Bool {
        UIScreen.main.bounds.height > 680
    }
    
    @Binding var animatePath: Bool
    @Binding var animateBG: Bool
    
    @Namespace var namespace
    
    var body: some View {

        ZStack(alignment: .leading) {
            
            Color("Background")
            
            VStack(alignment: .leading) {

                // Header
                HStack {

                    Button {
                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.3)) {
                            animatePath.toggle()
                        }
                        withAnimation {
                            animateBG.toggle()
                        }
                        withAnimation(.spring().delay(0.1)) {
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

                
                ForEach(Constants.categories.sorted(), id: \.self) { category in
                    if category != "None" {
                        Button {
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3)) {
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
                        .padding(.horizontal)
                        .buttonStyle(FlatButtonStyle())
                        .font(.title3.weight(.light))
                    }
                    
                    
                }
                
                Spacer()
                
                HStack {
                    
                    Button {
                        
                        selectedCategory = "None"
                        newCategory = ""
                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.3)) {
                            animatePath.toggle()
                        }
                        withAnimation {
                            animateBG.toggle()
                        }
                        withAnimation(.spring().delay(0.1)) {
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
                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.3)) {
                            animatePath.toggle()
                        }
                        withAnimation {
                            animateBG.toggle()
                        }
                        withAnimation(.spring().delay(0.1)) {
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
                .padding(.horizontal)
              

                Spacer()
            }
            .frame(width: screenWidth / 1.45)
            .padding()
            .padding(.top, isScreenLarge ? 40 : 25)
            
        }
        .clipShape(CategoryShape(curveValue: animatePath ? 70 : 0))
        .background(
            
            CategoryShape(curveValue: animatePath ? 70 : 0)
                .stroke(Color("Green1"), lineWidth: animatePath ? 9 : 0
                )
                .padding(.leading, -10)
        )
        .ignoresSafeArea()

    }
}

struct NewCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(selectedCategory: .constant("All"), showCategories: .constant(true), animatePath: .constant(false), animateBG: .constant(false))
    }
}

struct CategoryShape: Shape {
    
    var curveValue: CGFloat
    
    // animate path
    var animatableData: CGFloat {
        get { return curveValue }
        set { curveValue = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            let width = rect.width / 1.38
            let height = rect.height
            
            path.move(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            
            //Curve
            path.move(to: CGPoint(x: width, y: 0))
            path.addQuadCurve(to: CGPoint(x: width, y: height), control: CGPoint(x: width + curveValue, y: height / 2))
            
        }
    }
}
