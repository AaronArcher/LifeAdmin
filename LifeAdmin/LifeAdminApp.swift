//
//  LifeAdminApp.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 28/03/2022.
//

import SwiftUI

@main
struct LifeAdminApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @StateObject var spotlight = SpotlightVM()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(spotlight)
        }
    }
}
