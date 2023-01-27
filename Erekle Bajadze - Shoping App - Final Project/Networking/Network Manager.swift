//
//  Network Manager.swift
//  Erekle Bajadze - Shoping App - Final Project
//
//  Created by Erekle on 27.01.23.
//

import Foundation

class NetworkManager {
    enum NetworkError: Error {
        case wrongResponse, wrongStatusCode(Int)
    }
    
    static var shared = NetworkManager()
    
    func getData<T: Codable>(string: String, closure: @escaping (T?, Error?) -> Void){
        
        let urlString = string
        
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                closure(nil, NetworkError.wrongResponse)
                return
            }
            
            guard (200...399).contains(response.statusCode) else {
                closure(nil, NetworkError.wrongStatusCode(response.statusCode))
                return
            }
            
            guard let data else{
                return
            }
            
            do {
                
                let responseData = try JSONDecoder().decode(T.self, from: data)
                closure(responseData, nil)
            }
            
            catch {
                
                print(error)
            }
        }.resume()
    }
}
