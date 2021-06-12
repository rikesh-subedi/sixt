//
//  PillsView.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 11/06/21.
//

import SwiftUI

struct PillView: View {
    var image: Image
    var text: String
    var body: some View {
        HStack(spacing:2) {
            image
                .resizable()
                .frame(width: 10, height: 10)
            Text(text)
                .fontWeight(.bold)
                .font(.caption2)
        }
        .frame(maxWidth:.infinity)
        .padding(4)
        .background(Color.sAccent.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        //.shadow(color: Color.sAccent.opacity(0.5), radius:10)

    }
}

struct PillView_Previews: PreviewProvider {
    static var previews: some View {
        PillView(image: Image("transmission"), text: "hello")
    }
}
