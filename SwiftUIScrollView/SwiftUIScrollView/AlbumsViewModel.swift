//
//  AlbumsViewModel.swift
//  FlexisourceApp
//
//  Created by Roy Orpiano on 10/26/21.
//

import Foundation


struct Artist: Decodable {
    let ArtisId: Int?
    let Name: String?
}

extension Artist: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ArtisId)
        hasher.combine(Name)
    }
}

struct Volume: Decodable {
    let FirstTrackIndex: Int?
    let LastTrackIndex: Int?
}

extension Volume: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(FirstTrackIndex)
        hasher.combine(LastTrackIndex)
    }
}

struct AlbumLabel: Decodable {
    let LabelId: String?
    let Name: String?
}

extension  AlbumLabel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(LabelId)
        hasher.combine(Name)
    }
}


struct Release: Decodable {
    let ReleaseId: Int?
    let AlbumId: Int?
    let Artists: [Artist]?
    let Name: String?
    let IsExplicit: Bool?
    let NumberOfVolumes: Int?
    let TrackIds: [Int]?
    let Duration: Int?
    let Volumes: [Volume]?
    let Image: String?
    let Label: AlbumLabel?
    let ReleaseDate: String?
    let OriginalReleaseDate: String?
    let AllowDownload: Bool?
    let AllowStream: Bool?
    let ContentLanguage: String?
}

extension Release: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ReleaseId)
        hasher.combine(AlbumId)
        hasher.combine(Artists)
        hasher.combine(Name)
        hasher.combine(IsExplicit)
        hasher.combine(NumberOfVolumes)
        hasher.combine(TrackIds)
        hasher.combine(Duration)
        hasher.combine(Volumes)
        hasher.combine(Image)
        hasher.combine(Label)
        hasher.combine(ReleaseDate)
        hasher.combine(OriginalReleaseDate)
        hasher.combine(AllowDownload)
        hasher.combine(AllowStream)
        hasher.combine(ContentLanguage)
    }
}

struct Album: Decodable {
    let AlbumId: Int?
    let Name: String?
    let Upc: String?
    let Artists: [Artist]?
    let AlbumType: String?
    let PrimaryRelease: Release?
    let PrimaryReleaseId: Int?
    let ReleaseIds: [Int]?
    let Translations: [String]?
}

extension Album: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(AlbumId)
        hasher.combine(Name)
        hasher.combine(Upc)
        hasher.combine(Artists)
        hasher.combine(AlbumType)
        hasher.combine(PrimaryRelease)
        hasher.combine(PrimaryReleaseId)
        hasher.combine(ReleaseIds)
        hasher.combine(Translations)
    }
}

struct ResponseData: Decodable {
    let Offset: Int?
    let Count: Int?
    let Total: Int?
    let Results: [Album]?
}

class AlbumsViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case failed(String)
        case loaded([Album])
    }
    
    @Published private(set) var state = State.idle
    
    func load(fromOffSet offset:Int, to count:Int) {
        state = .loading
        
        Webservice.fetchAlbumsFromOffset(offSet: offset, count: count) { result in
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(ResponseData.self, from: data)

                    DispatchQueue.main.async {
                        self.state = .loaded(responseData.Results!)
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    self.state = .failed("error")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.state = .failed("error")
            }
        }
        
        
    }
}
