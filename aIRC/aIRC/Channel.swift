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
    init(aName:String){
        name = aName
    }
    override init() {
        name = ""
    }
}