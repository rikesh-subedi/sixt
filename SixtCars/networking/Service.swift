//
//  Service.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//
import SwiftUI
import Combine

enum NetworkError: Error {
    case unreachable
}

public protocol Service {
    associatedtype T:Codable
    init(apiClient: NetworkExecutable)
    var apiClient: NetworkExecutable {get}
    var baseURL: URL {get}
    var path: String {get}
    var parameters: [String:Any] {get}
    var headers: [String: Any]? {get}
}

extension Service {
    var request: URLRequest {
        guard var urlComponent = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            fatalError()
        }
        urlComponent.queryItems = parameters.map({ (keyValue) -> URLQueryItem in
            return URLQueryItem(name: keyValue.key, value: "\(keyValue.value)")
        })
        let request = URLRequest(url: urlComponent.url!)
        return request
    }

    var parameters: [String: Any] {
        return [:]
    }

    var headers: [String: Any]? {
        return [:]
    }

    func fetch() -> AnyPublisher<T, Error> {
        return self.apiClient
            .execute(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

}

