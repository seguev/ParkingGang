//
//  GPTLogic.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import Foundation
struct GPTLogic {
    func formQuery(question:String,imageDataString image:String) -> Data? {
        
        let fixedImageString = "data:image/jpeg;base64,\(image)"
        
        let question = Content(type: .text,
                               text: question,
                               image_url: nil)
        
        let image = Content(type: .imageUrl,
                            text: nil,
                            image_url: .init(url: fixedImageString,
                                             detail: .low))
        
        let message = QueryMessage(role: .user, content: [question,image])
        let query = GPTBodyModel(model: .gpt4VisionPreview, messages: [message], max_tokens: 500)
        do {
            return try JSONEncoder().encode(query)
        } catch {
            Logger.log(error)
            return nil
        }
    }
}
