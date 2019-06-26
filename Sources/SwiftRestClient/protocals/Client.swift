//
//  Client.swift
//  
//
//  Created by MIke B on 6/17/19.
//

import Foundation
import Combine

public protocol Client {}

public struct requestConfig {
    var timout: Double = 10.0
    
    public static var standard = requestConfig()
}

public extension Client {
    
    func request<T: Decodable>(_ endpoint: EndPoint, of type: T.Type, with config: requestConfig = .standard)->Publishers.TryMap<Publishers.Future<(Data, URLResponse), SwiftyRestClientError>, T>{
        request(endpoint, with: config).tryMap({ (data) in
            return try JSONDecoder().decode(T.self, from: data.0)
        })
    }
    
    
    func request(_ endpoint: EndPoint, with config: requestConfig = .standard)->Publishers.Future<(Data, URLResponse), SwiftyRestClientError>{
        
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path), timeoutInterval: config.timout)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        return Publishers.Future { (s: @escaping (Result<(Data, URLResponse), SwiftyRestClientError>) -> Void) in
            DispatchQueue.main.async(qos: .userInitiated) {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data, let response = response {
                        s(.success((data, response)))
                    }else if let error = error {
                        s(.failure(.lostConnection))
                    }else {
                        s(.failure(.unknownError))
                    }
                }
            }
        }
        
    }
    
}
