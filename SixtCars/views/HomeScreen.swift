//
//  HomeScreen.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 08/06/21.
//

import SwiftUI
import MapKit

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    let mapToolTipPosition = CGSize(width: 0, height: 30)
    @State var dragPosition: CGSize = CGSize(width: 0, height: 30)
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                MapView(region: $viewModel.mapRegion, cars: $viewModel.displayCars, selectedCar: $viewModel.selectedCar)

                if viewModel.selectedCar != nil {
                    CarDisplay(car: viewModel.selectedCar!)
                        .frame(width: proxy.size.width * 0.9, height: 100)
                        .offset(x: 0, y: proxy.safeAreaInsets.top)
                        .offset(dragPosition)
                        .transition(.move(edge: .top))
                        .opacity( abs(dragPosition.width) > 100 ? 0.5 : 1)
                        .gesture(
                            DragGesture(minimumDistance: 20, coordinateSpace: .global)
                                .onChanged { self.dragPosition = $0.translation}
                                .onEnded({ value in
                                    if abs(value.translation.width) > 100 || value.translation.height < -40 {
                                        self.dragPosition  = mapToolTipPosition
                                        withAnimation {
                                            viewModel.selectedCar = nil
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            self.dragPosition  = mapToolTipPosition
                                        }
                                    }

                                })
                        )
                        .transition(.opacity)
                }

                BottomSheetView(isOpen: $viewModel.isBottomSheetOpen, maxHeight: 600) {
                    VStack {
                        SearchField(searchText: $viewModel.filterText, placeHolder: viewModel.searchPlaceholderText)
                            .padding(8)
                            .background(Color.black.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        QuickSearchList(searchables: $viewModel.filters, searchDict: $viewModel.filterDict)
                        Spacer()
                            .frame(height:8)
                        Text(viewModel.numberOfCarsText)
                            .foregroundColor(.white)
                            .font(.caption2)
                        ScrollView(.vertical) {
                            LazyVStack {
                                ForEach(viewModel.displayCars, id: \.id) { annotatedCar in
                                    HStack {
                                        CarDisplay(car: annotatedCar)
                                    }
                                    .animation(.easeIn)
                                    .frame(maxWidth:.infinity)
                                }
                            }
                        }
                    }
                    .padding()

                }
            }
            .onAppear {
                viewModel.fetchCars()
            }
            .ignoresSafeArea()

        }
        }

}

struct HomeScreen_Previews: PreviewProvider {
    static var viewmodel: HomeViewModel = {
        let viewModel = HomeViewModel(carRepo: CarRepo(carService: GetCarService(apiClient: MockCarApiClient())))
        return viewModel
    }()
    static var previews: some View {

        HomeScreen(viewModel: viewmodel)
    }
}
