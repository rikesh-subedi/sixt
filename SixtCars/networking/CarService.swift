//
//  CarService.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import Combine
import Foundation

struct GetCarService: Service {
    typealias T = Array<Car>
    var apiClient: NetworkExecutable
    init(apiClient: NetworkExecutable) {
        self.apiClient = apiClient
    }
    var baseURL: URL {
        return URL(string: "https://cdn.sixt.io")!
    }

    var path: String {
        return "/codingtask/cars"
    }
}


struct MockCarApiClient: NetworkExecutable {
    func execute<T>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> where T : Decodable {
        let anypublisher = PassthroughSubject<Response<T>, Error>()
        let filePath = Bundle.main.path(forResource: "cars", ofType: "json")!
        let str = try! String.init(contentsOfFile: filePath)
        let value = try! JSONDecoder().decode(T.self, from: str.data(using: .utf8)!)
        let response = Response(value: value, response: URLResponse())
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            anypublisher.send(response)
        }
        return anypublisher.eraseToAnyPublisher()
    }
}
