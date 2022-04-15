//
//  SpotlightViewModel.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 15/04/2022.
//

import Foundation

class SpotlightVM: ObservableObject {
    @Published var currentSpotlight = 0
    @Published var isOnboarding = false
}
