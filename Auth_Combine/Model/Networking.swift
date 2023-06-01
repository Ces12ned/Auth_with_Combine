//
//  Networking.swift
//  Auth_Combine
//
//  Created by Edgar Cisneros on 31/05/23.
//

import Foundation


import UIKit

protocol NetworkingDelegate {
    
    func updateTable(users: [User])
}


class Networking{
    
    static let shared = Networking()
    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    var delegate: NetworkingDelegate?
    
    private init() {}
    

    func fetchData() async throws -> [User] {
        
        guard let safeURL = url else{
            return []
        }
        
        let (data, response) = try await URLSession.shared.data(from: safeURL)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {return [] }
        guard let safeData = try? JSONDecoder().decode([User].self, from: data) else {return [] }
        return safeData
    }

    func loadData(){
        Task(priority: .medium) {
            self.delegate?.updateTable(users: try await fetchData())
        }
        
    }
}
