//
//  ControlViewModel.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 24/04/2022.
//

import Foundation
import SwiftUI

@MainActor class ControlViewModel: ObservableObject {
    
    @Published var showNewAccount: Bool = false
    @Published var showSettings: Bool = false
    @Published var showCategories: Bool = false
    @Published var showSave: Bool = false
    @Published var showTabBar: Bool = true

    // for CategoriesView
    @Published var animatePath: Bool = false
    @Published var animateBG: Bool = false
    
}
