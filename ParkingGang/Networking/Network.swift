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
        Logger.log("url:",request)
        Logger.log("headers:",request.allHTTPHeaderFields ?? "no headers")
        Logger.log("body:\n",String(data: queryData, encoding: .utf8) ?? "no body" )
        let (data,res) = try await URLSession.shared.data(for: request)
        guard let response = res as? HTTPURLResponse else {fatalError()}
        Logger.log("Status Code:",response.statusCode)
        return data
    }
    
}

enum GptApi: String {
    case completions = "https://api.openai.com/v1/chat/completions"
}

//curl https://api.openai.com/v1/chat/completions \
//  -H "Content-Type: application/json" \
//  -H "Authorization: Bearer $OPENAI_API_KEY" \
//  -d '{
//    "model": "gpt-4-vision-preview",
//    "messages": [
//      {
//        "role": "user",
//        "content": [
//          {
//            "type": "text",
//            "text": "What’s in this image?"
//          },
//          {
//            "type": "image_url",
//            "image_url": {
//              "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg",
//              "detail": "high"
//            }
//          }
//        ]
//      }
//    ],
//    "max_tokens": 300
//  }'


//{
//  "max_tokens": 500,
//  "model": "gpt-4-vision-preview",
//  "messages": [
//    {
//      "content": [
//        {
//          "type": "text",
//          "text": "what do you see in the picture? with as little words as you can."
//        },
//        {
//          "type": "image_url",
//          "image_url": {
//            "url": "/9j/4AAQSkZJRgABAQAASABIAAD/4FFAH/9k=",
//            "detail": "low"
//          }
//        }
//      ],
//      "role": "user"
//    }
//  ],
//
//}
//
//{
//  "model": "gpt-4-vision-preview",
//  "messages": [
//    {
//      "role": "user",
//      "content": [
//        {
//          "type": "text",
//          "text": "What’s in this image?"
//        },
//        {
//          "type": "image_url",
//          "image_url": {
//            "url": f"data:image/jpeg;base64,{base64_image}"
//          }
//        }
//      ]
//    }
//  ],
//  "max_tokens": 300
//}
