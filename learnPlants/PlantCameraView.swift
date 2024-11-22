//
//  PlantCameraView.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/14/24.
//

import SwiftUI

struct PlantCameraView: View {
    @Binding var isPresented: Bool
    @Binding var currentImage: UIImage?
    
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        ZStack {
            // Camera feed preview
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Capture Button
                Button(action: {
                    camera.capturePhoto()
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                        .shadow(radius: 10)
                }
                .padding(.bottom, 50)
                
                // Cancel Button
                Button(action: {
                    isPresented = false // Dismiss the view
                }) {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
        }
        .onChange(of: camera.capturedImage) {
            if let image = camera.capturedImage {
                currentImage = image
                isPresented = false
            }
        }
    }
}
