//
//  QuickSearchList.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 11/06/21.
//

import SwiftUI

struct QuickSearchList: View {
    @Binding var searchables: [Searchable]
    @Binding var searchDict : [String: Searchable]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                Button(action: {
                    searchDict.removeAll()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .padding(5)
                        .opacity(searchDict.isEmpty ? 0.2 : 1)
                        .animation(.easeIn)

                }
                .foregroundColor(Color.sLight)
                ForEach(searchables, id: \.displayText)  { item in
                    Text(item.displayText)
                        .font(.system(size: 14, weight: .bold))
                        .padding(5)
                        .background(searchDict["\(type(of: item).groupId)"] != nil && searchDict["\(type(of: item).groupId)"]?.displayText == item.displayText ? Color.white : Color.sLight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            let type = "\(type(of: item).groupId)"
                            searchDict[type] = item
                        }
                        .animation(.easeIn)
                }
            }
        }
        .frame(height: 50)
    }
}

//struct QuickSearchList_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickSearchList(searchables: .constant(FuelType
//                                                .allCases), searchDict: .constant([String:Searchable]()))
//    }
//}
