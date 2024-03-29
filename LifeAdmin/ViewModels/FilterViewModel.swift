//
//  CategoryFilter.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 19/04/2022.
//

import Foundation
import CoreData
import SwiftUI

@MainActor class FilterViewModel: ObservableObject {
    
    @Published var selectedCategory: String = "None"
    @Published var showActive: Bool = true
    @Published var refreshTotal: Bool = true
    
    
    var predicate: NSPredicate? {
        switch(showActive, selectedCategory) {
        case (true, "Education"): return FilterPredicates.activeEducationPredicate
        case (false, "Education"): return FilterPredicates.inactiveEducationPredicate
        case (true, "Entertainment"): return FilterPredicates.activeEntertainmentPredicate
        case (false, "Entertainment"): return FilterPredicates.inactiveEntertainmentPredicate
        case (true, "Finance"): return FilterPredicates.activeFinancePredicate
        case (false, "Finance"): return FilterPredicates.inactiveFinancePredicate
        case (true, "Health & Fitness"): return FilterPredicates.activeHealthPredicate
        case (false, "Health & Fitness"): return FilterPredicates.inactiveHealthPredicate
        case (true, "Shopping"): return FilterPredicates.activeShoppingPredicate
        case (false, "Shopping"): return FilterPredicates.inactiveShoppingPredicate
        case (true, "Social Media"): return FilterPredicates.activeSocialMediaPredicate
        case (false, "Social Media"): return FilterPredicates.inactiveSocialMediaPredicate
        case (true, "Travel"): return FilterPredicates.activeTravelPredicate
        case (false, "Travel"): return FilterPredicates.inactiveTravelPredicate
        case (true, "Utilities"): return FilterPredicates.activeUtilitiesPredicate
        case (false, "Utilities"): return FilterPredicates.inactiveUtilitiesPredicate
        case (true, "Other"): return FilterPredicates.activeOtherPredicate
        case (false, "Other"): return FilterPredicates.inactiveOtherPredicate
            
        case (true, ""): return FilterPredicates.activePredicate
        case (false, ""): return FilterPredicates.inactivePredicate
        case (true, "None"): return FilterPredicates.activePredicate
        case (false, "None"): return FilterPredicates.inactivePredicate
            
        default: return FilterPredicates.activePredicate
        }
    }
}

// Predicates
struct FilterPredicates {
    
    static let activePredicate = NSPredicate(format: "isActive == true")
    static let inactivePredicate = NSPredicate(format: "isActive == false")
    
    static let educationPredicate = NSPredicate(format: "category == %@", "Education")
    static let activeEducationPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, educationPredicate])
    static let inactiveEducationPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, educationPredicate])

    static let entertainmentPredicate = NSPredicate(format: "category == %@", "Entertainment")
    static let activeEntertainmentPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, entertainmentPredicate])
    static let inactiveEntertainmentPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, entertainmentPredicate])
    
    static let financePredicate = NSPredicate(format: "category == %@", "Finance")
    static let activeFinancePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, financePredicate])
    static let inactiveFinancePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, financePredicate])
    
    static let healthPredicate = NSPredicate(format: "category == %@", "Health & Fitness")
    static let activeHealthPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, healthPredicate])
    static let inactiveHealthPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, healthPredicate])

    static let otherPredicate = NSPredicate(format: "category == %@", "Other")
    static let activeOtherPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, otherPredicate])
    static let inactiveOtherPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, otherPredicate])
    
    static let shoppingPredicate = NSPredicate(format: "category == %@", "Shopping")
    static let activeShoppingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, shoppingPredicate])
    static let inactiveShoppingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, shoppingPredicate])
 
    static let socialMediaPredicate = NSPredicate(format: "category == %@", "Social Media")
    static let activeSocialMediaPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, socialMediaPredicate])
    static let inactiveSocialMediaPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, socialMediaPredicate])
    
    static let travelPredicate = NSPredicate(format: "category == %@", "Travel")
    static let activeTravelPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, travelPredicate])
    static let inactiveTravelPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, travelPredicate])
    
    static let utilitiesPredicate = NSPredicate(format: "category == %@", "Utilities")
    static let activeUtilitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, utilitiesPredicate])
    static let inactiveUtilitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, utilitiesPredicate])
    
}
