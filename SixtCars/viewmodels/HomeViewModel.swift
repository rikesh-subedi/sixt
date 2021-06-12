//
//  HomeViewModel.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import Combine
import SwiftUI
import MapKit

final class HomeViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    let carRepo: CarRepo
    var cancellable: Cancellable? = nil
    private var allCars = [AnnotatedCar]()
    init(carRepo: CarRepo) {
        self.carRepo = carRepo
        self.displayCars = []
        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan())
        var items = [Searchable]()
        items.append(contentsOf: FuelType.allCases)
        items.append(contentsOf: CleanlinessType.allCases)
        items.append(contentsOf: TransmissionType.allCases)
        self.filters = items

    }

    @Published var isBottomSheetOpen = false {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published var selectedCar: AnnotatedCar? = nil {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published var searchPlaceholderText = "Name, Make or Model"

    @Published var numberOfCarsText = "" {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published var displayCars: [AnnotatedCar] {
        willSet {
            let count = newValue.count
            numberOfCarsText = "Found \(count) \(count > 1 ? "Cars" : "Car")"
            self.objectWillChange.send()
        }
    }

    @Published var filterText: String = "" {
        willSet {
            filterCarsByName(name: newValue)
            self.objectWillChange.send()
        }
    }

    @Published var filterDict  = [String: Searchable]() {
        willSet {
            setDisplayCars(filterBy: filterText, filterDict: newValue)
            self.objectWillChange.send()
        }
    }

    @Published var filters: [Searchable] = [] {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published var mapRegion: MKCoordinateRegion {
        willSet {
            self.objectWillChange.send()
        }
    }
    

    @Published var errorMessage: String?

    func fetchCars(){
        cancellable = self.carRepo.fetchCars()
            .receive(on: DispatchQueue.main)
            .sink{ error in
                self.errorMessage = "Something went wrong!."
            } receiveValue: { cars in
                self.allCars = cars.map({ car in
                    AnnotatedCar(car: car)
                })
                self.setDisplayCars(filterBy: self.filterText)

            }
    }

    private func setDisplayCars(filterBy name: String = "", filterDict: [String: Searchable]? = nil) {
        let searchName = name.lowercased().trimmingCharacters(in: .whitespaces)
        if searchName.isEmpty && (filterDict == nil || filterDict!.isEmpty) {
            self.displayCars = self.allCars
        } else {
            self.displayCars = self.allCars.filter({ displayCar in
                var found = searchName.isEmpty || (
                    displayCar.title.lowercased().contains(searchName) ||
                        displayCar.subtitle.lowercased().contains(searchName)
                )
                filterDict?.forEach({ (key, value) in
                    switch key {
                    case "\(FuelType.self)":
                         found = found && displayCar.fuelType == value.displayText
                        break
                    case "\(TransmissionType.self)":
                        found = found && displayCar.transmission == value.displayText
                        break
                    case "\(CleanlinessType.self)":
                        found = found && displayCar.cleanliness == value.displayText
                        break
                    default: break
                    }

                })
                return found
            })
        }
        if let firstCar = self.displayCars.first {
            self.mapRegion = MKCoordinateRegion(center:firstCar.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }

    }

    private func filterCarsByName(name: String) {
        setDisplayCars(filterBy: name)
    }
}
