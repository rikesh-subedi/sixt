//
//  CarRepoTest.swift
//  SixtCarsTests
//
//  Created by Subedi, Rikesh on 12/06/21.
//

import XCTest
import SixtCars
import Combine
class CarRepoTest: XCTestCase {

    func testCarRepo() throws {
        let expectation = self.expectation(description: "fetch from server should be called")
        struct MockClient: NetworkExecutable {
            var expectation:XCTestExpectation
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func execute<T>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> where T : Decodable {
                let anypublisher = PassthroughSubject<Response<T>, Error>()
                self.expectation.fulfill()
                return anypublisher.eraseToAnyPublisher()
            }
        }
        let carRepo = CarRepo(carService: GetCarService(apiClient: MockClient(expectation: expectation)))
        let _ = carRepo.fetchCars()
        wait(for: [expectation], timeout: 5)
        XCTAssert(true)
    }

}
