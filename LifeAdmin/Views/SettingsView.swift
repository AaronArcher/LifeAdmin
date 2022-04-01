//
//  SettingsView.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 31/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        
        VStack {

            Toggle("Dark Mode", isOn: $isDarkMode)
                .foregroundColor(Color("PrimaryText"))
                .tint(Color("Green1"))
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
        .preferredColorScheme(isDarkMode ? .dark : .light)


    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
