//
//  MainModel.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//

// MARK: - Leave Model
import Foundation

// MARK: - LeaveResponse Model
struct LeaveResponse: Decodable {
    
    let status      : Bool?
    let message     : String?
    let payload     : [Leave]
    let date        : String?
    
}

// MARK: - Leave Model
struct Leave: Decodable, Identifiable {
    
    let id          : Int?
    let user        : User?
    let startDate   : String?
    let reason      : String?
    
}

// MARK: - User Model
struct User: Decodable, Identifiable {
    
    let id              : Int?
    let fullName        : String?
}
