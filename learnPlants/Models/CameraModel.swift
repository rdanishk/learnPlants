//
//  CameraModel.swift
//  learnPlants
//
//  Created by Danish Khalid on 11/21/24.
//

import AVFoundation
import UIKit

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var capturedImage: UIImage?
    
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let queue = DispatchQueue(label: "camera.queue")
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        // Add photo input
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to access camera")
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // Add photo output
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.sessionPreset = .photo // Optimize for photo capture
        session.commitConfiguration()
    }
    
    func startSession() {
        print("Camera session started")
        queue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        queue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        print("Capture photo triggered")
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto // Automatically use flash if needed
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to capture photo or convert to UIImage")
            return
        }

        print("Photo captured successfully")
        DispatchQueue.main.async {
            print("Updating capturedImage")
            self.capturedImage = image
        }
    }

}
