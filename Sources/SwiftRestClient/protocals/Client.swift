//
//  Client.swift
//  
//
//  Created by MIke B on 6/17/19.
//

import Foundation
import Combine

public protocol Client {}

public enum requestError: Error {
    case unknown
}

public struct requestConfig {
    var timout: Double = 10.0
    
    public static var standard = requestConfig()
}

public extension Client {
    
    func request<T: Decodable>(_ endpoint: EndPoint, of type: T.Type, with config: requestConfig = .standard)->AnyPublisher<T,Error>{
        return requestRaw(endpoint, with: config).tryMap { (data) in
            try JSONDecoder().decode(T.self, from: data.data)
        }.eraseToAnyPublisher()
    }
//
//    func request(_ endpoint: EndPoint, with config: requestConfig = .standard)->some Publisher{
//        _request(endpoint, of: endpoint.object, with: config)
//        return (requestRaw(endpoint, with: config) ).map({ (data) in
//            try JSONDecoder().decode(endpoint.object.self, from: data.data)
//        })
//    }
    
    
    func requestRaw(_ endpoint: EndPoint, with config: requestConfig = .standard)->URLSession.DataTaskPublisher{
        
        
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path,isDirectory: false), timeoutInterval: config.timout)
         request.httpMethod = endpoint.httpMethod.rawValue
        
        do {
        
            switch endpoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestWith(let bodyParameters, let urlParameters):
                
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestWithHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                self.additionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            
        } catch {
            
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func additionalHeaders(_ additionalHeaders: HTTPHeader?, request: inout URLRequest) {
        guard let headers = additionalHeaders else {
            return
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
