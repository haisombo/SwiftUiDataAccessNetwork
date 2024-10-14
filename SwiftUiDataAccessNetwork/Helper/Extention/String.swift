//
//  String.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//

import Foundation

public extension String {
    //MARK: - Function
    func replace(of: String, with: String) -> String {
        return self.replacingOccurrences(of: of, with: with)
    }
    
}
