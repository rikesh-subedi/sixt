//
//  RemoteImage.swift
//  SixtCars
//
//  Created by Subedi, Rikesh on 09/06/21.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadingState {
        case loading, success, failure
    }

    private class Loader: ObservableObject{
        var data: UIImage?
        var state = LoadingState.loading
        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                self.state = .failure
                return
            }
            if let image = ImageCacheManager.getImage(serverPath: url) {
                self.data = image
                self.state = .success
                return
            }

            URLSession.shared.dataTask(with: parsedURL) {
                data, response , error in
                if let data = data, data.count > 0 {
                    self.state = .success
                    self.data = UIImage(data: data)
                    ImageCacheManager.saveImage(serverPath: url, image: self.data)
                } else {
                    self.state = .failure
                }
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    var body: some View {
        selectImage()
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    init(url: String, placeholder: Image = Image("image-placeholder")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = placeholder
        self.failure = self.loading
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = loader.data {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "")
    }
}
