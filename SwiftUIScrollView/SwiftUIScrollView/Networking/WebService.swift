//
//  WebService.swift
//  FlexisourceApp
//
//  Created by Roy Orpiano on 10/26/21.
//

import Foundation

let storeId = "luJdnSN3muj1Wf1Q"

class Webservice {
    
    static func fetchAlbumsFromOffset(offSet:Int, count countNum: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        let endPoint = "https://api-metadata-connect.tunedglobal.com/api/v2.1/albums/trending?offset=\(offSet)&count=\(countNum)"
        
        let url: URL? = URL(string: endPoint)
        
        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(storeId, forHTTPHeaderField: "StoreId")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3 * 60
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if error != nil {
                completion(.failure(error!))
            } else {
                let error = NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
