//
//  PlantCameraView.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/14/24.
//

import SwiftUI
import PhotosUI

struct PlantCameraView: View {
    @Binding var isPresented: Bool
    @Binding var currentImage: UIImage?

    @StateObject private var camera = CameraModel()
    @State private var showGalleryPicker = false // Controls the gallery presentation

    var body: some View {
        ZStack {
            // Camera feed preview
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    // Return Icon Button
                    Button(action: {
                        isPresented = false // Dismiss the camera view
                    }) {
                        Image("return_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
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
                    
                    Spacer()
                    
                    // Gallery Thumbnail
                    Button(action: {
                        showGalleryPicker = true // Trigger gallery presentation
                    }) {
                        if let image = currentImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 50, height: 50)
                                .overlay(Text("📷").font(.headline).foregroundColor(.white))
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
        }
        .onChange(of: camera.capturedImage) { newImage in
            if let image = newImage {
                currentImage = image
                isPresented = false
            }
        }
        .sheet(isPresented: $showGalleryPicker) {
            PhotosPickerView(currentImage: $currentImage, isPresented: $showGalleryPicker)
        }
    }
}
