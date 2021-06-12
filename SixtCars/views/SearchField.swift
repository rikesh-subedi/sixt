//
//  SearchField.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 11/06/21.
//

import SwiftUI



struct SearchField: View {
    @Binding var searchText: String
    var placeHolder: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .renderingMode(.template)
                .foregroundColor(.gray)
            TextField("", text: $searchText)
                .modifier(PlaceholderStyle(showPlaceHolder: searchText.isEmpty,
                                           placeholder: placeHolder))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.white)
                .accentColor(.white)

            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
            }.foregroundColor(.white)
        }
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(searchText: .constant(""), placeHolder: "Start Typing")
    }
}
