//
//  ContentView.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PlantViewModel()
    
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var showDetailView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Welcome to ") + Text("Which Plant?").italic()
                Button(action: {
                    isShowingCamera = true
                }, label: {
                    Text("Press me to check plant")
                })
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
        }
    }
}

#Preview {
    ContentView()
}
