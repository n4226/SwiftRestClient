//
//  Client.swift
//  
//
//  Created by MIke B on 6/17/19.
//

import Foundation
import Combine

public protocol Client {}

struct ClientPublisher: Publisher {
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        
    }
    
    public typealias Output = (data: Data,responce: URLResponse)
    
    public typealias Failure = SwiftyRestClientError
}

public extension Client {
    
    
    
    func request(_ endpoint: EndPoint, with timeout: TimeInterval = 10.0)->ClientPublisher  guth{
        
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path), timeoutInterval: timeout)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            
        }
        
    }
    
}
