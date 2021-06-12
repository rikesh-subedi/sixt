//
//  MapView.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 10/06/21.
//

import SwiftUI
import MapKit
import Combine

struct MapView: View {
    @Binding var region : MKCoordinateRegion
    @Binding var cars: [AnnotatedCar]
    @Binding var selectedCar: AnnotatedCar?
    @State var showCarPopover = false
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: cars) { annotatedCar in
                MapAnnotation(coordinate: annotatedCar.coordinate) {
                    RemoteImage(url: annotatedCar.imageURL, placeholder: Image("car-icon"))
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if let sCar = selectedCar, sCar.id == annotatedCar.id {
                                withAnimation {
                                    selectedCar = nil
                                    showCarPopover = false
                                }
                            } else {
                                withAnimation {
                                    selectedCar = nil
                                    selectedCar = annotatedCar
                                    showCarPopover = true
                                }

                            }

                        }
                        .background((selectedCar?.id ?? "") == annotatedCar.id ? Color.sAccent : Color.sLight)
                        .animation(.default)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 25/10))
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                }

            }
            .animation(.easeIn)
            
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var cars:[Car] = {
        var data = """
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
           },{
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
        return try! JSONDecoder().decode([Car].self, from: data)
    }()
    static var previews: some View {
        MapView(region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(cars[0].latitude), longitude: CLLocationDegrees(cars[0].longitude)), span: MKCoordinateSpan())), cars: .constant(cars.map{AnnotatedCar(car: $0)}), selectedCar: .constant(nil))
    }
}
