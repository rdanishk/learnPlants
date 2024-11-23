//
//  PlantCameraView.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/14/24.
//

import SwiftUI
import PhotosUI

struct PlantCameraView: View {
    @ObservedObject var cameraModel: CameraModel
    @State private var selectedItem: PhotosPickerItem?

    var dismiss: () -> Void // Closure to handle dismissal of the view

    var body: some View {
        ZStack {
            // Camera feed preview
            CameraUIView(camera: cameraModel)
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    // Return Icon Button
                    Button(action: {
                        dismiss() // Call the dismiss closure
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
                        print("Capture button pressed")
                        cameraModel.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                            .shadow(radius: 10)
                    }

                    Spacer()

                    // Gallery Picker Button
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let image = cameraModel.capturedImage {
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
            cameraModel.startSession()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .onChange(of: selectedItem) { newItem in
            if let newItem = newItem {
                loadPhoto(from: newItem)
            }
        }
    }

    private func loadPhoto(from item: PhotosPickerItem) {
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cameraModel.capturedImage = image
                    }
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}
