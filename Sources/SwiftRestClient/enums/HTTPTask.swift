//
//  HTTPTask.swift
//  
//
//  Created by MIke B on 6/17/19.
//

import Foundation

public typealias HTTPHeader = [String : String]

public enum HTTPTask {
    case request
    case requestWith(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestWithHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeader?)
    
}
