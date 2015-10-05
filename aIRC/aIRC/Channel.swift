//
//  Channel.swift
//  aIRC
//
//  Created by Tim Harris on 9/16/15.
//  Copyright © 2015 Tim Harris. All rights reserved.
//

import Foundation

class Channel: NSObject {
    var name:String
    var autoConnect: Bool
    
    init(aName:String){
        name = aName
        autoConnect = false
    }
    override init() {
        name = ""
        autoConnect = false
    }
}