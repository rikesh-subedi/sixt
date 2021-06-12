//
//  CarRepo.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import Combine
class CarRepo {
    let carService: GetCarService
    var cancellable: Cancellable?
    init(carService: GetCarService) {
        self.carService = carService
    }

    func fetchCars() -> Future<[Car], Error> {
        let pub = Future<[Car], Error>.init {[weak self] promise in
            self?.cancellable = self?.carService.fetch()
                .sink { error in
                    print(error)
                    promise(.failure(NetworkError.unreachable))
                } receiveValue: { response in
                    promise(.success(response))
                }
        }
        return pub
    }
}

