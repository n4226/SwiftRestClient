//
//  Endpoint.swift
//
//
//  Created by N4226 B on 6/17/19.
//


import Foundation

public protocol EndPoint {
    
//    associatedtype object: Decodable
    
    var apiClientKey: String? { get }
    var apiClientSecret: String? { get }
    var baseURL: URL { get }
    var path: String { get }
//    var object: Decodable.Protocol { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeader? { get }
}
