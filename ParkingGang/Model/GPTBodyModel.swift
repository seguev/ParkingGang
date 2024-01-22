//
//  GPTBodyModel.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import Foundation

struct GPTBodyModel: Encodable {
    let model: Model
    let messages: [Message]
    let max_tokens: Int
    
    enum Model: String, Encodable {
        case gpt4VisionPreview = "gpt-4-vision-preview"
    }
}

struct Message: Encodable {
    let role: Role
    let content: [Content]
    
    enum Role: String, Encodable {
        case user = "user"
    }
}

struct Content: Encodable {
    let type: ContentType
    let text: String?
    let image_url: ImageUrlType?
    
    enum ContentType: String, Encodable {
        case text = "text"
        case imageUrl = "image_url"
    }
    
}

struct ImageUrlType: Encodable {
    let url: String
    let detail: Detail
    
    enum Detail: String, Encodable {
        case high = "high"
        case low = "low"
    }
}

