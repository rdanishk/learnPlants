//
//  PlantViewModel.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/13/24.
//

import Foundation
import UIKit
import ImageIO
import CoreLocation

class PlantViewModel: ObservableObject {
    @Published var plantDetail: PlantModel?
    private let plantIDService = PlantIdentifyService()
    
    func loadData(image: UIImage?) {
        guard let actualImage = image else {
            return
        }
        
        let imageData = getImageData(image: actualImage)
        
        guard let base64img = imageData.base64img else {
            return
        }
        
        plantIDService.fetchDataWithHeader(imageBase64: base64img,
                                           latitude: imageData.latitude ?? 0.0,
                                           longitude: imageData.longitude ?? 0.0,
                                           similar_images: true) { result in
            switch result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                   let jsonDataPretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: jsonDataPretty, encoding: .utf8) {
                    print(jsonString)
                }
                if let plant = self.parsePlantData(data) {
                    DispatchQueue.main.async {
                        self.plantDetail = plant
                    }
                } else {
                    print("No data to print")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func getImageData(image: UIImage) -> (base64img: String?, latitude: Double?, longitude: Double?) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return (nil, nil, nil)
        }
        
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        if let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) {
            guard let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
                return (base64String, nil, nil)
            }
            if let gpsData = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any] {
                let latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double
                let longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double
                let latitudeRef = gpsData[kCGImagePropertyGPSLatitudeRef] as? String
                let longitudeRef = gpsData[kCGImagePropertyGPSLongitudeRef] as? String
                
                let finalLatitude = (latitudeRef == "S") ? -(latitude ?? 0.0) : latitude
                let finalLongitude = (longitudeRef == "W") ? -(longitude ?? 0.0) : longitude
                
                return (base64String, finalLatitude, finalLongitude)
            }
        }
        return (base64String, nil, nil)
    }
    
    private func parsePlantData(_ jsonData: Data) -> PlantModel? {
        do {
            let decoder = JSONDecoder()
            let plantModel = try decoder.decode(PlantModel.self, from: jsonData)
            print(plantModel.result.classification.suggestions.first?.name ?? "JEDI worked cant print tho")
            return plantModel
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
