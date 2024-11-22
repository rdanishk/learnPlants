//
//  CameraPreview.swift
//  learnPlants
//
//  Created by Danish Khalid on 11/21/24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.previewLayer = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.previewLayer?.videoGravity = .resizeAspectFill
        camera.previewLayer?.frame = view.frame
        if let layer = camera.previewLayer {
            view.layer.addSublayer(layer)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
