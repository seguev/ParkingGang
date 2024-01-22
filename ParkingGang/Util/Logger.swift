//
//  Logger.swift
//  ParkingGang
//
//  Created by segev perets on 22/01/2024.
//

import Foundation
struct Logger {
    private init(){}
    static func log(_ items:Any...) {
        #if(DEBUG)
        print("ℹ️ ",items)
        #endif
    }
}
