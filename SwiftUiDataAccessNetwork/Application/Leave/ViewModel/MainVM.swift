//
//  MainVM.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//

import Foundation
import Alamofire

class UserViewModel: ObservableObject {
    
    @Published var leaves: [Leave] = []
    @Published var errorMessage: String?

    func fetchLeaves() {
        let endpoint = EndPoint(path: APIPaths.leavePath, method: .get, parameters: nil, headers: nil)
        NetworkManager.shared.request(endpoint: endpoint) { [weak self] (result: Result<LeaveResponse, AFError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.leaves = response.payload
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
