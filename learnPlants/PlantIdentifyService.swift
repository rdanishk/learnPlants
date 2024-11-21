//
//  PlantIdentifyService.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/13/24.
//

import Foundation

class PlantIdentifyService {
    let urlString = "https://plant.id/api/v3/identification?details=common_names,url,description,taxonomy,rank,gbif_id,inaturalist_id,image,synonyms,edible_parts,watering,best_light_condition,best_soil_type,common_uses,cultural_significance,toxicity,best_watering&language=en"
    let apiKey = "eK4vLHggWMQfyRRY67GGtTG4EkvnfNYtxwuYhmcqofS1nxW02j"
    
    func fetchDataWithHeader(imageBase64: String,
                             latitude: Double,
                             longitude: Double,
                             similar_images: Bool,
                             completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("invalid URL string")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let requestBody: [String: Any] = [
            "images": [imageBase64],
            "latitude": latitude,
            "longitude": longitude,
            "similar_images": similar_images
        ]
        
        do {
               let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
               request.httpBody = jsonData
           } catch {
               print("Failed to encode request body: \(error.localizedDescription)")
               return
           }
           
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   completion(.failure(error)) // Correct usage of .failure
                   return
               }
               
               guard let data = data else {
                   // Use completion with an error when no data is received
                   completion(.failure(NSError(domain: "PlantIdentifyService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                   return
               }
               
               completion(.success(data)) // Correct usage of .success
           }
           task.resume()
    }
}
