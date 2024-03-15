//
//  Network.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import Foundation
struct Network {
    private init() {}
    static let shared = Network()
//    #error("should send two different request, one with type text and a question and second with just an image")
    func postRequest(_ api:GptApi,queryData:Data) async throws -> Data {
        guard let url = URL(string: api.rawValue) else {fatalError("Wrong url")}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer " + Secrets.apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = queryData
        
        let (data,res) = try await URLSession.shared.data(for: request)
        guard let response = res as? HTTPURLResponse else {fatalError()}
        Logger.log("Status Code:",response.statusCode)
        return data
    }
    
}

enum GptApi: String {
    case completions = "https://api.openai.com/v1/chat/completions"
}
