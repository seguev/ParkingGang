//
//  GPTLogic.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import Foundation
struct GPTLogic {
    func formQuery(question:String,imageDataString image:String) -> Data? {
        let body: GPTBodyModel = .init(model: .gpt4VisionPreview,
                                       messages: [
                                        .init(role: .user,
                                              content: [
                                                .init(type: .imageUrl,
                                                      text: question,
                                                      image_url: .init(url: "data:image/jpeg;base64,\(image)"
                                                                       , detail: .low))
                                              ])
                                       ],
                                       max_tokens: 200)
        do {
            return try JSONEncoder().encode(body)
        } catch {
            Logger.log(error)
            return nil
        }
    }
}
