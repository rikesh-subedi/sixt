//
//  ApiClient.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import SwiftUI
import Combine

public struct Response<T> {
    let value: T
    let response: URLResponse
    public init(value: T, response: URLResponse) {
        self.value = value
        self.response = response
    }
}

public protocol NetworkExecutable {
    func execute<T:Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error>
}

struct APIClient: NetworkExecutable {
    func execute<T:Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (result) -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .breakpointOnError()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
