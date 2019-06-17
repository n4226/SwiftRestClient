//
//  Errors.swift
//
//  Created by Rodolfo Roca on 12/10/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public enum SwiftyRestClientError: Error {
    case parametersNil
    case encodingFailed
    case decodingFailed
    case missingURL
    case wrongURL
    case lostConnection
    case notFound
    case saveError
    case unknownError
}
