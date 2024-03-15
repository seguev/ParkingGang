//
//  Constants.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import Foundation
struct Constants {
    private init(){}
    
    static let gpt4VisionPreview = "gpt-4-vision-preview"
    
    struct UserDefaultKeys {
        private init(){}
        static let parkingNum = "parkingNum"
    }
    
    struct Prompt {
        private init(){}

        static var gptImagePrompt: String {
            let today = UserData.shared.today
            let time = Date().formatted(date: .omitted, time: .shortened)
            let parkingNum: String = if UserData.shared.parkingNum > 0 {
                "Parking area number " + UserData.shared.parkingNum.description
            } else {
                "No parking area symbol"
            }
            
            return "This is a parking sign written in hebrew, today is \(today) at \(time) and i have \(parkingNum). am I allowed to park my car here right now? include 'yes' or 'no' in your answer and the shortest explenation you can give, if not stated, assume its allowed"
        }
        static let mockPrompt = "what do you see in the picture? with as little words as you can."
    }
    
    
}

