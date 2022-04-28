//
//  CategoriesView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 10/04/2022.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var filterVM: FilterViewModel
    @EnvironmentObject var controlVM: ControlViewModel
    
    @State private var newCategory = ""
        

    
    @Namespace var namespace
    
    var body: some View {

        ZStack(alignment: .leading) {
            
            Color("Background")
                .accessibility(hidden: true)
            
            VStack(alignment: .leading) {

                //MARK: Header
                HStack {

                    Button {
                        DispatchQueue.main.async {
                            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.3)) {
                                controlVM.animatePath.toggle()
                            }
                            withAnimation {
                                controlVM.animateBG.toggle()
                            }
                            withAnimation(.spring().delay(0.1)) {
                                controlVM.showCategories.toggle()
                            }
                            if filterVM.selectedCategory != newCategory {
                                newCategory = ""
                            }
                        }
                        
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("PrimaryText"))
                            .font(.title2.weight(.light))
                            .frame(width: 30, height: 30)
                    }

                    Spacer()

                    Text("Categories")
                        .font(Constants.isScreenLarge ? .largeTitle.weight(.light) : .title.weight(.light))
                        .foregroundColor(Color("Green1"))

                    Spacer()

                    Color.clear
                        .frame(width: 30, height: 30)
                }
                .padding(.bottom)
                .padding(.bottom, Constants.isScreenLarge ? 20 : 0)
                
                
                Text("Filter your accounts by:")
                    .font(Constants.isScreenLarge ? .title2.weight(.light) : .title3.weight(.light))
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.bottom, Constants.isScreenLarge ? 40 : 25)
                

                ScrollView(showsIndicators: false) {
                    
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
                                        .fill(
                                            LinearGradient(colors: [Color("Green1"), Color("Green1"), Color("Green2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .frame(height: 40)
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
            }
                .frame(height: Constants.screenHeight / 1.75)
                
                Spacer()
                
                HStack {
                    
                    Button {
                        
                        DispatchQueue.main.async {
                            filterVM.selectedCategory = "None"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                newCategory = ""
                            }
                            
                            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.3)) {
                                controlVM.animatePath.toggle()
                            }
                            withAnimation {
                                controlVM.animateBG.toggle()
                            }
                            withAnimation(.spring().delay(0.1)) {
                                controlVM.showCategories.toggle()
                            }
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
                        
                        DispatchQueue.main.async {
                            filterVM.selectedCategory = newCategory
                            
                            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.3)) {
                                controlVM.animatePath.toggle()
                            }
                            withAnimation {
                                controlVM.animateBG.toggle()
                            }
                            withAnimation(.spring().delay(0.1)) {
                                controlVM.showCategories.toggle()
                            }
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
                    .opacity((filterVM.selectedCategory == newCategory) || (newCategory == "") ? 0.7 : 1)
                    .disabled((filterVM.selectedCategory == newCategory) || (newCategory == ""))
                    
                
                }
                .padding(.horizontal)
                .padding(.bottom, Constants.isScreenLarge ? 50 : 20)
              

            }
            .frame(width: Constants.screenWidth / 1.45)
            .padding()
            .padding(.top, Constants.isScreenLarge ? 40 : 25)
            
        }
        .clipShape(CategoryShape(curveValue: controlVM.animatePath ? 70 : 0))
        .background(
            
            CategoryShape(curveValue: controlVM.animatePath ? 70 : 0)
                .stroke(Color("Green1"), lineWidth: controlVM.animatePath ? 4 : 0
                )
        )
        .ignoresSafeArea()

    }
}

struct NewCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
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
            
            path.move(to: CGPoint(x: width, y: height + 10))
            path.addLine(to: CGPoint(x: -10, y: height + 10))
            path.addLine(to: CGPoint(x: -10, y: -10))
            path.addLine(to: CGPoint(x: width, y: -10))
            
            //Curve
            path.move(to: CGPoint(x: width, y: -10))
            path.addQuadCurve(to: CGPoint(x: width, y: height + 10), control: CGPoint(x: width + curveValue, y: height / 2))
            
        }
    }
}
