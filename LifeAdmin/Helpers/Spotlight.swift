//
//  SpotlightHelp.swift
//  LifeAdmin
//
//  Created by Aaron Johncock on 13/04/2022.
//

import Foundation
import SwiftUI
import UIKit

// From Kavsoft Tutorial
// Custom spotlight modifier
extension View {
    func spotlight(enabled: Bool, title: String = "") -> some View {
        return self
            .overlay {
                if enabled {
                    // To get the current content size
                    GeometryReader { proxy in
                        let rect = proxy.frame(in: .global)
                        
                        SpotlightView(rect: rect, title: title) {
                            self
                        }
                    }
                }
            }
    }
    
    // Screen Bounds
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    // Root Controller
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}


struct SpotlightView<Content: View>: View {
    
    var content: Content
    var rect: CGRect
    var title: String
    
    init(rect: CGRect, title: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.title = title
        self.rect = rect
    }
    
    @State var tag: Int = 1009
    
    var body: some View {
        Rectangle()
        // fill with white to avoid user interaction
            .fill(.white.opacity(0.02))
            .onAppear {
                addOverlayView()
            }
    }
    
    // Remove the overlay when the view disappears
    func removeOverlay() {
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag {
                view.removeFromSuperview()
            }
        
        }
    }
    
    
    // Add an extra view over current view
    // by extracting the UIView from the view controller
    func addOverlayView() {
        
        // Convert SwiftUI to UIKit
        let hostingView = UIHostingController(rootView: overlaySwiftUIView())
        hostingView.view.frame = screenBounds()
        hostingView.view.backgroundColor = .clear
        
        
        // To identify which view has been added, add a tag to the view
        // sometimes Swiftui on appear will be called twice
        // to avoid adding this twice...
        if self.tag == 1009 {
            self.tag = randomNumber()
        }
        hostingView.view.tag = self.tag
        
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag { return }
        }
        
        // Adding to the current view
        rootController().view.addSubview(hostingView.view)
        
    }
    
    @ViewBuilder
    func overlaySwiftUIView() -> some View {
        ZStack {
            
            
            Rectangle()
                .fill(Color("Spotlight").opacity(0.92))
            // Reverse mask the current highlighted area
                .mask({
                    
                    // If the height and width are almost the same then make it a circle, otherwise a rounded rectangle
                    let radius = (rect.height / rect.width) > 0.7 ? rect.width : 6
                    
                    Rectangle()
                        .overlay {
                            content
                                .frame(width: rect.width, height: rect.height)
                            // A bit more highlighted area
                                .padding(10)
                                .background(.white, in: RoundedRectangle(cornerRadius: radius))
                            // Move to correct plact - Position will place at the top left of the screen so use the rect midX&Y to offset to correct position
                                .position()
                                .offset(x: rect.midX, y: rect.midY)
                                .blendMode(.destinationOut)
                        }
                })
            
            // Display Text
            if title != "" {
                Text(title)
                .font(.title.bold())
                .foregroundColor(.white)
                .position()
                .offset(x: screenBounds().midX, y: rect.maxY > (screenBounds().height - 150) ? (rect.minY - 150) : (rect.maxY + 150))
                .padding()
//                .lineLimit(2)
            }
        }
            .frame(width: screenBounds().width, height: screenBounds().height)
            .ignoresSafeArea()
    }
    
    // Random number for tag
    func randomNumber() -> Int {
        let random = Int(UUID().uuid.0)
        
        // Check to see if there is a view with that tag already
        let subviews = rootController().view.subviews
        
        for index in subviews.indices {
            if subviews[index].tag == random {
                return randomNumber()
            }
        }
        return random
    }
    
}
