//
//  ContentView.swift
//  SwiftUIScrollView
//
//  Created by Roy Orpiano on 11/10/21.
//

import SwiftUI

private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

struct AlbumImage: View {
    var maxWidth: CGFloat
    var imageURLString: String
    @State private var isLoaded = false
    @ObservedObject var imageLoader = AlbumImageLoaderService()
    @State var image: UIImage = UIImage()
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(8)
            .frame(width: maxWidth, height: maxWidth)
            .cornerRadius(10)
            .onReceive(imageLoader.$image) { image in
                self.isLoaded.toggle()
                self.image = image
            }
            .onAppear {
                imageLoader.loadImage(for: imageURLString)
            }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: AlbumsViewModel
    @State private var albums: [Album] = [Album]()
//    @State private var isLoaded = false
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Text("loading").onAppear {
                viewModel.load(fromOffSet: 20, to: 10)
            }
        case .loading:
            ProgressView()
        case .failed(let errorString):
            Text(errorString)
        case .loaded(let albums):
            GeometryReader { g in
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 0) {
                        ForEach(albums, id: \.self) { album in
                            AlbumImage(maxWidth: g.size.width/3,
                                imageURLString: album.PrimaryRelease?.Image! ?? "https://tunedglobal-a.akamaihd.net/images1004/100/4_0/060/253/759/320/0/104_1004_00602537593200_20210224_2200.jpg")
                        }
                    }
                }
            }
        }
    }
    
    init() {
        self.viewModel = AlbumsViewModel()
    }
}

#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
#endif
