//
//  PlantViewModel.swift
//  learnPlants
//
//  Created by Danish Khalid on 10/13/24.
//

import Foundation

// MARK: - PlantModel
struct PlantModel: Codable {
    let accessToken, modelVersion: String
    let customID: JSONNull?
    let input: Input
    let result: Result
    let status: String
    let slaCompliantClient, slaCompliantSystem: Bool
    let created, completed: Double

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case modelVersion = "model_version"
        case customID = "custom_id"
        case input, result, status
        case slaCompliantClient = "sla_compliant_client"
        case slaCompliantSystem = "sla_compliant_system"
        case created, completed
    }
}

// MARK: - Input
struct Input: Codable {
    let latitude, longitude: Double
    let similarImages: Bool
    let images: [String]
    let datetime: String

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case similarImages = "similar_images"
        case images, datetime
    }
}

// MARK: - Result
struct Result: Codable {
    let classification: Classification
    let isPlant: IsPlant

    enum CodingKeys: String, CodingKey {
        case classification
        case isPlant = "is_plant"
    }
}

// MARK: - Classification
struct Classification: Codable {
    let suggestions: [Suggestion]
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let id, name: String
    let probability: Double
    let similarImages: [SimilarImage]
    let details: Details

    enum CodingKeys: String, CodingKey {
        case id, name, probability
        case similarImages = "similar_images"
        case details
    }
}

// MARK: - Details
struct Details: Codable {
    let commonNames: [String]?
    let taxonomy: Taxonomy?
    let url: String?
    let gbifID, inaturalistID: Int?
    let rank: String?
    let description: Description?
    let synonyms: [String]?
    let image: Description?
    let edibleParts: EdibleParts?
    let watering: Watering?
    let bestLightCondition, bestSoilType, commonUses, culturalSignificance: String?
    let toxicity, bestWatering, language, entityID: String?

    enum CodingKeys: String, CodingKey {
        case commonNames = "common_names"
        case taxonomy, url
        case gbifID = "gbif_id"
        case inaturalistID = "inaturalist_id"
        case rank, description, synonyms, image
        case edibleParts = "edible_parts"
        case watering
        case bestLightCondition = "best_light_condition"
        case bestSoilType = "best_soil_type"
        case commonUses = "common_uses"
        case culturalSignificance = "cultural_significance"
        case toxicity
        case bestWatering = "best_watering"
        case language
        case entityID = "entity_id"
    }
}

// MARK: - Watering Enum
enum Watering: Codable {
    case string(String)
    case dictionary([String: String])
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let dictionaryValue = try? container.decode([String: String].self) {
            self = .dictionary(dictionaryValue)
        } else {
            self = .none
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .none:
            try container.encodeNil()
        }
    }
}

// MARK: - EdibleParts Enum
enum EdibleParts: Codable {
    case string(String)
    case array([String])
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            self = .none
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .none:
            try container.encodeNil()
        }
    }
}

// MARK: - Taxonomy
struct Taxonomy: Codable {
    let taxonomyClass, genus, order, family: String?
    let phylum, kingdom: String?

    enum CodingKeys: String, CodingKey {
        case taxonomyClass = "class"
        case genus, order, family, phylum, kingdom
    }
}

// MARK: - Description
struct Description: Codable {
    let value: String?
    let citation: String?
    let licenseName: String?
    let licenseURL: String?

    enum CodingKeys: String, CodingKey {
        case value, citation
        case licenseName = "license_name"
        case licenseURL = "license_url"
    }
}

// MARK: - SimilarImage
struct SimilarImage: Codable {
    let id: String
    let url: String
    let licenseName: String?
    let licenseURL: String?
    let citation: String?
    let similarity: Double
    let urlSmall: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case licenseName = "license_name"
        case licenseURL = "license_url"
        case citation, similarity
        case urlSmall = "url_small"
    }
}

// MARK: - IsPlant
struct IsPlant: Codable {
    let probability, threshold: Double
    let binary: Bool
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
