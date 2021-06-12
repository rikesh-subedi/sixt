//
//  ContentView.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import SwiftUI

struct ContentView: View {
    let homeViewModel = HomeViewModel(carRepo: CarRepo(carService: GetCarService(apiClient: APIClient())))
    var body: some View {
        HomeScreen(viewModel: homeViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
