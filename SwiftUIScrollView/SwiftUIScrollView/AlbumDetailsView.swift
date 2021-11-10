//
//  AlbumDetailsView.swift
//  KDAlbums
//
//  Created by Roy Orpiano on 11/10/21.
//

import SwiftUI

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}


struct AlbumDetailsView: View {
    var album: Album
    @ObservedObject private var imageLoader = AlbumImageLoaderService()
    @State var image: UIImage = UIImage()
    @State private var isLoaded: Bool = false
    
    var body: some View {
        GeometryReader { g in
            VStack{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .frame(width: g.size.width-20, height: g.size.width-20)
                    .cornerRadius(10)
                    .onReceive(imageLoader.$image) { image in
                        self.isLoaded = true
                        self.image = image
                    }
                    .onAppear {
                        self.image = UIImage(systemName: "photo")!
                        imageLoader.loadImage(for: album.PrimaryRelease?.Image! ?? "")
                    }
                
                HStack(
                    alignment: .top,
                    spacing: 8
                ) {
                    Text("Album Name:").foregroundColor(.gray)
                    Text("\(album.Name!)")
                }
                
            }
        }
    }
}

//let a:[String: Any] = ["name": "Myley Cyrus", "artist": "MyleyCyrus"]
//struct AlbumDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumDetailsView(album: a)
//    }
//}
