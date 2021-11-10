//
//  AlbumsViewModel.swift
//  FlexisourceApp
//
//  Created by Roy Orpiano on 10/26/21.
//

import Foundation


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
