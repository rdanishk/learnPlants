//
//  PlantDetailView.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/16/24.
//

import SwiftUI

struct PlantDetailView: View {
    let plant: PlantModel

    init(plant: PlantModel) {
        self.plant = plant
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Check if plant suggestions exist
                if let firstSuggestion = plant.result.classification.suggestions.first {
                    // Display common name or scientific name
                    let commonName = firstSuggestion.details.commonNames?.first?.capitalized ?? firstSuggestion.name.capitalized
                    let scientificName = firstSuggestion.name
                    
                    // Display name and scientific name
                    Text("This is a plant!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(commonName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(scientificName)
                        .italic()
                        .padding(.bottom, 10)
                    
                    // Images Section
                    if !firstSuggestion.similarImages.isEmpty {
                        Text("Pictures:")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(firstSuggestion.similarImages, id: \.id) { image in
                                    AsyncImage(url: URL(string: image.urlSmall)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 300, height: 300)
                                                .cornerRadius(15)
                                        } else if phase.error != nil {
                                            Color.red.frame(width: 300, height: 300)
                                                .cornerRadius(15)
                                                .overlay(
                                                    Text("Error loading image")
                                                        .foregroundColor(.white)
                                                        .font(.caption)
                                                )
                                        } else {
                                            ProgressView()
                                                .frame(width: 300, height: 300)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Additional plant details
                    let details = firstSuggestion.details
                    
                    // Description
                    if let description = details.description?.value {
                        Text("Description:")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                    }
                    
                    // Best Light Condition
                    if let bestLightCondition = details.bestLightCondition, !bestLightCondition.isEmpty {
                        Text("Best Light Condition:")
                            .font(.headline)
                        Text(bestLightCondition)
                            .font(.body)
                    }

                    // Best Soil Type
                    if let bestSoilType = details.bestSoilType, !bestSoilType.isEmpty {
                        Text("Best Soil Type:")
                            .font(.headline)
                        Text(bestSoilType)
                            .font(.body)
                    }

                    // Common Uses
                    if let commonUses = details.commonUses, !commonUses.isEmpty {
                        Text("Common Uses:")
                            .font(.headline)
                        Text(commonUses)
                            .font(.body)
                    }

                    // Cultural Significance
                    if let culturalSignificance = details.culturalSignificance, !culturalSignificance.isEmpty {
                        Text("Cultural Significance:")
                            .font(.headline)
                        Text(culturalSignificance)
                            .font(.body)
                    }

                    // Toxicity
                    if let toxicity = details.toxicity, !toxicity.isEmpty {
                        Text("Toxicity:")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(toxicity)
                            .font(.body)
                            .foregroundColor(.red)
                    }

                    // Best Watering
                    if let bestWatering = details.bestWatering, !bestWatering.isEmpty {
                        Text("Watering Guide:")
                            .font(.headline)
                        Text(bestWatering)
                            .font(.body)
                    }
                    
                    // Taxonomy Details
                    if let taxonomy = details.taxonomy {
                        Text("Taxonomy:")
                            .font(.headline)
                        Text("Class: \(taxonomy.taxonomyClass ?? "Unknown")")
                            .font(.body)
                        Text("Genus: \(taxonomy.genus ?? "Unknown")")
                            .font(.body)
                        Text("Order: \(taxonomy.order ?? "Unknown")")
                            .font(.body)
                        Text("Family: \(taxonomy.family ?? "Unknown")")
                            .font(.body)
                        Text("Phylum: \(taxonomy.phylum ?? "Unknown")")
                            .font(.body)
                        Text("Kingdom: \(taxonomy.kingdom ?? "Unknown")")
                            .font(.body)
                    }
                    
                } else {
                    // Fallback when there are no suggestions or the plant is not detected
                    Text("This is not a plant!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                }
            }
            .padding()
            .navigationTitle("Plant Details")
        }
    }
}
