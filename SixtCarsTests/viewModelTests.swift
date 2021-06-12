//
//  viewModelTests.swift
//  SixtCarsTests
//
//  Created by Subedi, Rikesh on 12/06/21.
//

import XCTest
import Combine
import SixtCars
class viewModelTests: XCTestCase {

    var cancellable : Cancellable?
    var mockClient: NetworkExecutable {
        struct MockClient: NetworkExecutable {
            func execute<T>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> where T : Decodable {
                let data = """
                  [{
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
                    "carImageUrl": "https://cdn.sixt.io/codingtask/images/mini.png"
                  },
                  {
                    "id": "WMWSU31070T077232",
                    "modelIdentifier": "mini",
                    "modelName": "MINI",
                    "name": "Regine",
                    "make": "BMW",
                    "group": "MINI",
                    "color": "midnight_black",
                    "series": "MINI",
                    "fuelType": "P",
                    "fuelLevel": 0.55,
                    "transmission": "M",
                    "licensePlate": "M-I7425",
                    "latitude": 48.114988,
                    "longitude": 11.598359,
                    "innerCleanliness": "CLEAN",
                    "carImageUrl": "https://cdn.sixt.io/codingtask/images/mini.png"
                  }]
                """.data(using: .utf8)!
                let cars = try! JSONDecoder().decode(T.self, from: data)
                return Just(Response(value: cars, response: URLResponse()))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
        return MockClient()
    }

    override func tearDownWithError() throws {
        cancellable = nil
    }

    func testViewModelFetchCars() throws {
        let expectation = self.expectation(description: "fetch cars")
        let carRepo = CarRepo(carService: GetCarService(apiClient: mockClient))
        let viewModel = HomeViewModel(carRepo: carRepo)
        viewModel.fetchCars()
        cancellable = viewModel.$displayCars.sink { cars in
            if cars.count == 2 {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
        XCTAssert(true)
    }

    func testViewModelFilter() throws {
        let expectation = self.expectation(description: "fetch cars")
        let carRepo = CarRepo(carService: GetCarService(apiClient: mockClient))
        let viewModel = HomeViewModel(carRepo: carRepo)
        viewModel.fetchCars()
        viewModel.filterText = "Vanessa"
        cancellable = viewModel.$displayCars.sink { cars in
            if cars.count == 1 {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
        XCTAssert(true)
    }

}
