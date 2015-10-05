//
//  Preferences.swift
//  aIRC
//
//  Created by Tim Harris on 10/4/15.
//  Copyright © 2015 Tim Harris. All rights reserved.
//

import Foundation

class Preferences: NSObject, NSCoding {
    var autoConnectToServers:Bool
    var cacheMedia: Bool
    var cacheMediaDuration: Int
    
    override init() {
        autoConnectToServers = false
        cacheMedia = false
        cacheMediaDuration = 1
    }
    required init?(coder aDecoder: NSCoder) {
        autoConnectToServers =  aDecoder.decodeObjectForKey("autoConnectToServers") as! Bool
        cacheMedia = aDecoder.decodeObjectForKey("cacheMediaDuration") as! Bool
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(autoConnectToServers, forKey: "autoConnectToServers")
    }
    
    func hasCacheMediaDuration() -> Int?{
        
    }
}