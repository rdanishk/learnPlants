//
//  PhotoPreviewView.swift
//  learnPlants
//
//  Created by Danish Khalid on 11/22/24.
//

import SwiftUI

struct PhotoPreviewView: View {
    @Binding var image: UIImage?
    @Binding var isConfirmed: Bool
    var dismiss: () -> Void // Closure to handle dismissal
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    // Discard Button
                    Button(action: {
                        image = nil
                        dismiss() // Call the dismiss closure
                    }) {
                        Text("Discard")
                            .font(.custom("Lora-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(ColorPalette.shared.delicateBrown)
                            .cornerRadius(40)
                    }
                    
                    Spacer()
                    
                    // Confirm Button
                    Button(action: {
                        isConfirmed = true
                        dismiss() // Call the dismiss closure after confirming
                    }) {
                        Text("Use Photo")
                            .font(.custom("Lora-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(ColorPalette.shared.mustard)
                            .cornerRadius(40)
                    }
                }
                .padding()
            }
            .onAppear {
                print("PhotoPreviewView appeared with image: \(String(describing: image))")
            }
            .onDisappear {
                print("PhotoPreviewView dismissed")
            }
        }
    }
}
