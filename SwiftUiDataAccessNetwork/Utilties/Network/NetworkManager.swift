//
//  NetworkManager.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//


import Alamofire
import Foundation

// MARK: - NetworkService Protocol
protocol NetworkService {
    func request<T: Decodable>(endpoint: EndPoint, completion: @escaping (Result<T, AFError>) -> Void)
}

// MARK: - NetworkManager
class NetworkManager: NetworkService {
    
    // Singleton Instance
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(endpoint: EndPoint, completion: @escaping (Result<T, AFError>) -> Void) {
        // Construct the URL
        guard let url = URL(string: Environment.baseURL + endpoint.path) else {
            Log.e("Invalid URL: \(Environment.baseURL + endpoint.path)")
            completion(.failure(AFError.invalidURL(url: Environment.baseURL + endpoint.path)))
            return
        }
        
        // Define Headers
        let headers: HTTPHeaders = endpoint.headers ?? [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzb2tjaGVuZyIsImV4cCI6MTcyODk3MDExMCwiaWF0IjoxNzI4ODgzNzEwLCJ1c2VJbnR0SWQiOiJVVExaXzU5MCIsInVzZXJuYW1lIjoic29rY2hlbmcifQ.1UqerdMjmjux40jDGPaDk4qpuyxw2jjx-zt_XuEPnk9yaP9MShQUUgVJJWR4zkjw88zkwE9J092JsTQZ2Jjz_g" // Replace this with your valid token
        ]
        
        // Log the Request Details
        Log.r("""
            Request - URL: \(url),
            Headers: \(headers),
            Parameters: \(String(describing: endpoint.parameters ?? [:]))
        """)
        
        // Perform the Network Request
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300) // Validate acceptable status codes
            .responseData { response in
                switch response.result {
                case .success(let data):
                    
                    // Use prettyPrinted to log the raw JSON response for debugging purposes
                    Log.s("Pretty Printed JSON Response: \n\(data.prettyPrinted )")
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        Log.s("Decoded Data: \(decodedData)")
                        completion(.success(decodedData))
                    } catch {
                        Log.e("Decoding Error: \(error.localizedDescription)")
                        completion(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
                    }
                    
                case .failure(let error):
                    Log.e("Network Request Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
