//
//  PhotosPickerView.swift
//  learnPlants
//
//  Created by Danish Khalid on 11/22/24.
//

import SwiftUI
import PhotosUI

struct PhotosPickerView: View {
    @Binding var currentImage: UIImage?
    @Binding var isPresented: Bool

    @State private var selectedItem: PhotosPickerItem?
    @State private var pickerReady = false // Ensures picker launches only once

    var body: some View {
        EmptyView()
            .onAppear {
                // Trigger picker presentation after a slight delay to avoid conflicts
                if !pickerReady {
                    pickerReady = true
                }
            }
            .photosPicker(
                isPresented: $pickerReady,
                selection: $selectedItem,
                matching: .images
            )
            .onChange(of: selectedItem) { newItem in
                if let newItem = newItem {
                    loadPhoto(from: newItem)
                } else {
                    // Dismiss when user cancels
                    isPresented = false
                }
            }
    }

    private func loadPhoto(from item: PhotosPickerItem) {
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        currentImage = image
                        isPresented = false // Dismiss picker after selection
                    }
                }
            } catch {
                print("Error loading image: \(error)")
                DispatchQueue.main.async {
                    isPresented = false // Dismiss on error
                }
            }
        }
    }
}
