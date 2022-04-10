//
//  Extensions.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 10/04/2022.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

}
#endif
