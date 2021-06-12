//
//  CarDisplay.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 09/06/21.
//

import SwiftUI

struct CarDisplay: View {
    var car: AnnotatedCar
    var body: some View {
        HStack(alignment:.top) {
            VStack {
                RemoteImage(url: car.imageURL)
                    .frame(width: 150, height: 100, alignment: .center)
                    .background(Color.sAccent.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped(antialiased: true)
                    .shadow(color: Color.sDarkAccent.opacity(0.3), radius:10)
                Text(car.licensePlate)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.sDark)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .font(.subheadline)
            }
            
            VStack(alignment:.leading) {
                Text(car.title)
                    .font(.title)
                    .fontWeight(.bold)
                Text(car.subtitle)
                    .font(.subheadline)
                HStack(spacing:8) {
                    PillView(image: Image("cleanliness"), text: car.cleanliness)
                    PillView(image: Image("transmission"), text: car.transmission)
                }
                HStack(spacing:8) {
                    PillView(image: Image("fuel"), text: car.fuelType)
                    PillView(image: Image("fuel"), text: car.fuelLevel)
                }

            }
            //.foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.sAccent.opacity(0.5))
            .shadow(color: Color.sDark.opacity(0.3), radius:10)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.sDarkAccent.opacity(1))
        .clipShape(RoundedRectangle(cornerRadius:10))
    }
}

struct CarDisplay_Previews: PreviewProvider {
    static var car:Car = {
        var data = """
           {
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
             "carImageUrl": ""
           }
        """.data(using: .utf8)!
        return try! JSONDecoder().decode(Car.self, from: data)
    }()
    static var previews: some View {
        CarDisplay(car: AnnotatedCar(car: car))
    }
}
