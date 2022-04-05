//
//  FilterPredicates.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 05/04/2022.
//

import Foundation

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

    static let otherPredicate = NSPredicate(format: "category == %@", "Other")
    static let activeOtherPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [activePredicate, otherPredicate])
    static let inactiveOtherPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inactivePredicate, otherPredicate])
 
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
