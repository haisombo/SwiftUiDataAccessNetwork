//
//  EndPoint.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//
import Foundation
import Alamofire

// MARK: - EndPoint Configuration
struct EndPoint {
    
    var path        : String
    var method      : HTTPMethod
    var parameters  : [String: Any]?
    var headers     : HTTPHeaders?
    
}
