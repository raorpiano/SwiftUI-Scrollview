//
//  ContentView.swift
//  SwiftUIScrollView
//
//  Created by Roy Orpiano on 11/10/21.
//

import SwiftUI

private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

extension View {
    @ViewBuilder func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct AlbumImage: View {
    var maxWidth: CGFloat
    var album: Album
    @ObservedObject var imageLoader = AlbumImageLoaderService()
    @State var image: UIImage = UIImage()
    @State var isLoaded = false
    
    var body: some View {
        NavigationLink(destination: AlbumDetailsView(album: album)) {
            
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
                    imageLoader.loadImage(for: album.PrimaryRelease?.Image! ?? "")
                }
            
        
        }
    }
}

struct AlbumsView: View {
    @ObservedObject var viewModel: AlbumsViewModel
    @State private var albums: [Album] = [Album]()
//    @State private var isLoaded = false
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Text("loading").onAppear {
                viewModel.load(fromOffSet: 10, to: 30)
            }
        case .loading:
            ProgressView()
        case .failed(let errorString):
            Text(errorString)
        case .loaded(let albums):
            
            GeometryReader { g in
                NavigationView {
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 0) {
                                ForEach(albums, id: \.self) { album in
                                    AlbumImage(maxWidth: g.size.width/3, album: album)
                                }
                        }
                    }
                    .navigationBarTitle("Tuned Global")
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
