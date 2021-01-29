//
//  ListeVoituresJSONLocalTests.swift
//  ListeVoituresJSONLocalTests
//
//  Created by Koussaïla Ben Mamar on 28/01/2021.
//

import XCTest
@testable import ListeVoituresJSONLocal

class ListeVoituresJSONLocalTests: XCTestCase {

    func testParseJSONData() throws {
        let json = """
        {
            "cars": [
                {
                    "brandName": "Ferrari",
                    "imageName": "ferrari-logo",
                    "models": [
                        {
                            "modelName": "488 Pista",
                            "year": 2018,
                            "engine": "V8",
                            "power": 720,
                            "maxSpeed": 340,
                            "price": 291770
                        },
                        {
                            "modelName": "LaFerrari",
                            "year": 2013,
                            "engine": "V12 Hybride",
                            "power": 963,
                            "maxSpeed": 372,
                            "price": 1250000
                        }
                    ]
                }
            ]
        }
        """
        
        let jsonData = json.data(using: .utf8)
        XCTAssertNotNil(jsonData)
        
        let carData = try! JSONDecoder().decode(CarBrands.self, from: jsonData!)
        XCTAssertNotNil(carData)
    
        XCTAssertEqual("Ferrari", carData.cars?[0].brandName)
        XCTAssertNotEqual("Maserati", carData.cars?[0].brandName)
        
        XCTAssertEqual("488 Pista", carData.cars?[0].models?[0].modelName)
        XCTAssertNotEqual("SF90 Stradale", carData.cars?[0].models?[0].modelName)
    }
    
    func testParseJSONDataFile() throws {
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        let data = try Data(contentsOf: url)
        let listeVoitures = try JSONDecoder().decode(CarBrands.self, from: data)
        XCTAssertNotNil(listeVoitures)
        XCTAssertGreaterThan(listeVoitures.cars?.count ?? 0, 0)
    
        XCTAssertEqual("Ferrari", listeVoitures.cars?[0].brandName)
        XCTAssertNotEqual("Maserati", listeVoitures.cars?[0].brandName)
        
        XCTAssertEqual("488 Pista", listeVoitures.cars?[0].models?[0].modelName)
        XCTAssertNotEqual("SF90 Stradale", listeVoitures.cars?[0].models?[0].modelName)
    }
}
