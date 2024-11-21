//
//  ContentView.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/13/24.
//

import SwiftUI

// Color palette no. 4511
struct ColorPalette {
    static let shared = ColorPalette()
    
    let olive: Color = Color(red: 0.32, green: 0.35, blue: 0.12)
    let mustard: Color = Color(red: 0.78, green: 0.73, blue: 0.40)
    let taupe: Color = Color(red: 0.74, green: 0.62, blue: 0.48)
    let delicateBrown: Color = Color(red: 0.87, green: 0.83, blue: 0.77)
    let marine: Color = Color(red: 0.21, green: 0.51, blue: 0.51)
}

struct ContentView: View {
    @StateObject var viewModel = PlantViewModel()
    
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var showDetailView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.shared.taupe.ignoresSafeArea()
                Image("plant_raw")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                VStack {
                    (
                        Text("Welcome to ").font(.custom("Montserrat-ExtraBold", size: 30)) +
                        Text("Which Plant?").font(.custom("Montserrat-ExtraBoldItalic", size: 32)).foregroundColor(ColorPalette.shared.olive)
                    ).padding(.top, 60)
                    Button(action: {
                            isShowingCamera = true
                        }) {
                            Text("Press to find out!")
                                .font(.custom("Lora-Regular", size: 18)) // Bold font
                                .foregroundColor(.white) // Text color
                                .padding() // Internal padding
                                .background(ColorPalette.shared.mustard) // Button background
                                .cornerRadius(40) // Rounded corners
                                .shadow(radius: 5) // Shadow for raised effect
                                .padding(.top, 375)
                        }
                    Text("This app will identify plants, help you learn about them and guide you on a journey to grow healthy plants in your home.")
                        .font(.custom("HindMadurai-Regular", size: 14))
                        .padding(.top, 50)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .foregroundColor(ColorPalette.shared.olive)
                    Spacer()
                    }.fullScreenCover(isPresented: $isShowingCamera, onDismiss: {
                        if let capturedImage = capturedImage {
                            viewModel.loadData(image: capturedImage)
                        }
                }) {
                    PlantCameraView(isPresented: $isShowingCamera, currentImage: $capturedImage)
                }.onReceive(viewModel.$plantDetail) { plant in
                    if plant != nil {
                        showDetailView = true
                    }
                }.navigationDestination(isPresented: $showDetailView) {
                    if let plantDetail = viewModel.plantDetail {
                        PlantDetailView(plant: plantDetail)
                    }
                }
            }.onAppear(perform: logAvailableFonts) // Log fonts on appear
        }
    }
    
    
    // Function to log available fonts
    private func logAvailableFonts() {
        for family in UIFont.familyNames {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("    Font Name: \(name)")
            }
        }
    }
}

#Preview {
    ContentView()
}
