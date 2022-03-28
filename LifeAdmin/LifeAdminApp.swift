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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
