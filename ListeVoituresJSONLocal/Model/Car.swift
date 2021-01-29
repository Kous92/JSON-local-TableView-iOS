//
//  Car.swift
//  Liste voitures JSON
//
//  Created by Koussaïla Ben Mamar on 21/01/2021.
//

import Foundation

struct CarBrands: Codable {
    let cars: [Cars]?
}

struct Cars: Codable {
    let brandName: String?
    let imageName: String?
    let models: [Car]?
}

struct Car: Codable {
    let modelName: String?
    let year: Int?
    let engine: String?
    let power: Int?
    let maxSpeed: Int?
    let price: Int?
}
