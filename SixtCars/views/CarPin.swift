//
//  CarPin.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 11/06/21.
//

import SwiftUI

struct CarPin: View {
    var body: some View {

        GeometryReader { proxy in
            let minSide = min(proxy.size.width, proxy.size.height)
            let maxSide = max(proxy.size.width, proxy.size.height)
            let width: CGFloat = minSide
            let height = width
            Path { path in

                path.move(to: CGPoint(x: 0 , y: 0))
                path.addLines([
                    CGPoint(x: 0 , y: 0),
                    CGPoint(x: width , y: 0),
                    CGPoint(x: width, y: height),
                    CGPoint(x: 0, y: height),
                    CGPoint(x: 0, y: 0)
                ])
            }
            .transform(.init(translationX: 0, y: (maxSide - minSide)/2))
            .stroke()
            .contentShape(Circle())
        }


    }
}

struct CarPin_Previews: PreviewProvider {
    static var previews: some View {
        CarPin()
    }
}
