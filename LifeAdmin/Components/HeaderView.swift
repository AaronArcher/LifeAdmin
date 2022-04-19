//
//  HeaderView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI


struct HeaderView: View {
    
    
    var text: String
    
    var body: some View {
        ZStack {
            HeaderShape()
                .fill(
                    LinearGradient(colors: [Color("Green1"), Color("Green1"), Color("Green1"), Color("Green2")], startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)

                Text(text)
                    .font(.largeTitle.weight(.light))
                    .foregroundColor(.white)
                    .frame(width: Constants.screenWidth / 1.4, height: 40)
                    .fixedSize(horizontal: true, vertical: true)
                    .dynamicTypeSize(.large)
         
            
            
        }
        .frame(height: Constants.screenHeight / 6)
        

    }
}
struct HeaderView_Previews: PreviewProvider {
    
    static var previews: some View {
        HeaderView(text: "Active Accounts")
    }
}


struct HeaderShape: Shape {
    func path(in rect: CGRect) -> Path {
      
        var path = Path()
        
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 30))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.maxY - 30), control: CGPoint(x: rect.midX, y: rect.maxY + 30))
        path.addLine(to: CGPoint.zero)
      
        
        return path
    }
}

