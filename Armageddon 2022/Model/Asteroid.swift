//
//  Asteroid.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 20.04.2022.
//

import UIKit

struct Objects: Codable {
    let nearEarthObjects: [String: [NearEarthObject]]
    
    enum CodingKeys: String, CodingKey {
        case nearEarthObjects = "near_earth_objects"
    }
}
struct NearEarthObject: Codable {
    let id: String
    let name: String
    let estimatedDiameter: EstimatedDiameter
    let isPotentiallyHazardousAsteroid: Bool
    let closeApproachData: [CloseApproachDate]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case closeApproachData = "close_approach_data"
    }
}
struct CloseApproachDate: Codable {
    let closeApproachDateFull: String
    let missDistance: MissDistance
    
    enum CodingKeys: String, CodingKey {
        case closeApproachDateFull = "close_approach_date"
        case missDistance = "miss_distance"
    }
}
struct MissDistance: Codable {
    var kilometers: String
}
struct EstimatedDiameter: Codable {
    let meters: Meters
}
struct Meters: Codable {
    let estimatedDiameterMin, estimatedDiameterMax: Double
    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}
