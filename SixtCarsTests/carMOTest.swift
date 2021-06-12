//
//  carMOTest.swift
//  SixtCarsTests
//
//  Created by Subedi, Rikesh on 12/06/21.
//

import XCTest

class carMOTest: XCTestCase {
    func testJSONDecoding() {
        let data = """
           {
             "id": "WMWSW31030T222518",
             "modelIdentifier": "mini",
             "modelName": "MINI",
             "name": "Vanessa",
             "make": "BMW",
             "group": "MINI",
             "color": "midnight_black",
             "series": "MINI",
             "fuelType": "D",
             "fuelLevel": 0.7,
             "transmission": "M",
             "licensePlate": "M-VO0259",
             "latitude": 48.134557,
             "longitude": 11.576921,
             "innerCleanliness": "REGULAR",
             "carImageUrl": ""
           }
        """.data(using: .utf8)!
        let car = try? JSONDecoder().decode(Car.self, from: data)
        XCTAssert(car != nil)
    }

    func testConversionToAnnotateCar() {
        let data = """
           {
             "id": "WMWSW31030T222518",
             "modelIdentifier": "mini",
             "modelName": "MINI",
             "name": "Vanessa",
             "make": "BMW",
             "group": "MINI",
             "color": "midnight_black",
             "series": "MINI",
             "fuelType": "D",
             "fuelLevel": 0.7,
             "transmission": "M",
             "licensePlate": "M-VO0259",
             "latitude": 48.134557,
             "longitude": 11.576921,
             "innerCleanliness": "REGULAR",
             "carImageUrl": ""
           }
        """.data(using: .utf8)!
        let car = try! JSONDecoder().decode(Car.self, from: data)
        let annotatedCar = AnnotatedCar(car: car)
        XCTAssert(annotatedCar.title == "Vanessa")
        XCTAssert(annotatedCar.subtitle == "BMW (MINI)")
    }


}
