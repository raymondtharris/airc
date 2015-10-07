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
    
    var useNameForAll: Bool
    var useNicknameForAll: Bool
    
    override init() {
        autoConnectToServers = false
        cacheMedia = false
        cacheMediaDuration = 1
        useNameForAll = true
        useNicknameForAll = true
    }
    required init?(coder aDecoder: NSCoder) {
        autoConnectToServers =  aDecoder.decodeBoolForKey("autoConnectToServers")
        cacheMedia = aDecoder.decodeBoolForKey("cacheMediaDuration")
        cacheMediaDuration = aDecoder.decodeIntegerForKey("cacheMediaDuration")
        useNameForAll = aDecoder.decodeBoolForKey("useNameForAll")
        useNicknameForAll = aDecoder.decodeBoolForKey("useNicknameForAll")
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(autoConnectToServers, forKey: "autoConnectToServers")
        aCoder.encodeBool(cacheMedia, forKey: "cacheMedia")
        aCoder.encodeInteger(cacheMediaDuration, forKey: "cacheMediaDuration")
        aCoder.encodeBool(useNameForAll, forKey: "useNameForAll")
        aCoder.encodeBool(useNicknameForAll, forKey: "useNicknameForAll")
    }
    
    func hasCacheMediaDuration() -> Int{
        return 1
    }
}