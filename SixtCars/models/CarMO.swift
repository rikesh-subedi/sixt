//
//  CarMO.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import Foundation
import CoreLocation

protocol Searchable {
    static var groupId: Self.Type {get}
    var displayText: String {get}
}

extension Searchable {
    static var groupId: Self.Type {
        return self
    }
}

enum FuelType: String, Codable, CaseIterable {
    case P
    case D
    case E
}

extension FuelType: Searchable{

    var displayText: String {
        switch self {
        case .P:
            return "Petrol"
        case .D:
            return "Diesel"
        case .E:
            return "Electric"
        }
    }
}

enum TransmissionType: String, Codable, CaseIterable {
    case M
    case A
}

extension TransmissionType: Searchable {
    var displayText: String {
        switch self {
        case .A:
            return "Automatic"
        case .M:
            return "Manual"
        }
    }
}

enum CleanlinessType: String, Codable, CaseIterable {
    case CLEAN
    case REGULAR
    case VERY_CLEAN
}

extension CleanlinessType: Searchable {
    var displayText: String {
        switch self {
        case .CLEAN:
            return "Clean"
        case .REGULAR:
            return "Regular"
        case .VERY_CLEAN:
            return "Very Clean"
        }
    }
}

struct Car: Codable {
    var id: String
    var modelIdentifier: String
    var name: String
    var make: String
    var series: String
    var color: String
    var fuelType: FuelType
    var fuelLevel: Float
    var transmission: TransmissionType
    var licensePlate: String
    var latitude: Float
    var longitude: Float
    var innerCleanliness: CleanlinessType
    var carImageUrl: String
}


struct AnnotatedCar: Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var fuelType: String
    var fuelLevel: String
    var transmission: String
    var licensePlate: String
    var cleanliness: String
    var coordinate: CLLocationCoordinate2D
    var imageURL: String
    init(car: Car) {
        self.id = car.id
        self.title = car.name
        self.subtitle = "\(car.make) (\(car.series))"
        self.fuelType = car.fuelType.displayText
        self.fuelLevel = String(format: "%.1f%%", car.fuelLevel * 100)
        self.cleanliness = car.innerCleanliness.displayText
        self.licensePlate = car.licensePlate
        self.transmission = car.transmission.displayText
        self.imageURL = car.carImageUrl
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(car.latitude), longitude: CLLocationDegrees(car.longitude))
    }
}
