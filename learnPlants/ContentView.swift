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
    enum ActiveSheet: Identifiable {
        case camera, galleryPicker, preview
        
        var id: Int {
            hashValue
        }
    }
    
    @StateObject var viewModel = PlantViewModel()
    
    @State private var capturedImage: UIImage? = nil
    @State private var showDetailView = false
    @State private var activeSheet: ActiveSheet?
    @State private var confirmPhoto = false
    
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
                        Text("Which Plant?").font(.custom("Montserrat-ExtraBoldItalic", size: 32))
                            .foregroundColor(ColorPalette.shared.olive)
                    )
                    .padding(.top, 60)
                    
                    Button(action: {
                        activeSheet = .camera
                    }) {
                        Text("Press to find out!")
                            .font(.custom("Lora-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(ColorPalette.shared.mustard)
                            .cornerRadius(40)
                            .shadow(radius: 5)
                            .padding(.top, 375)
                    }
                    
                    Text("This app will identify plants, help you learn about them and guide you on a journey to grow healthy plants in your home.")
                        .font(.custom("HindMadurai-Regular", size: 14))
                        .padding(.top, 50)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .foregroundColor(ColorPalette.shared.olive)
                    
                    Spacer()
                }
                .onChange(of: capturedImage) { newImage in
                    if let _ = newImage {
                        activeSheet = .preview // Navigate to the preview
                    }
                }
                .onChange(of: confirmPhoto) { confirmed in
                    if confirmed, let image = capturedImage {
                        print("Making API call with the confirmed image...")
                        viewModel.loadData(image: image) // API call
                    }
                }
                .onReceive(viewModel.$plantDetail) { plant in
                    if plant != nil {
                        showDetailView = true
                    }
                }
                .navigationDestination(isPresented: $showDetailView) {
                    if let plantDetail = viewModel.plantDetail {
                        PlantDetailView(plant: plantDetail)
                    }
                }
                .sheet(item: $activeSheet) { item in
                    switch item {
                    case .camera:
                        PlantCameraView(isPresented: Binding(get: { activeSheet == .camera }, set: { activeSheet = $0 ? .camera : nil }), currentImage: $capturedImage)
                    case .galleryPicker:
                        ImagePicker(selectedImage: $capturedImage, isPresented: Binding(get: { activeSheet == .galleryPicker }, set: { activeSheet = $0 ? .galleryPicker : nil }))
                    case .preview:
                        PhotoPreview(image: $capturedImage, isPresented: Binding(get: { activeSheet == .preview }, set: { activeSheet = $0 ? .preview : nil }), isConfirmed: $confirmPhoto)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
