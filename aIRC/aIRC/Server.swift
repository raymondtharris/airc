//
//  Server.swift
//  aIRC
//
//  Created by Tim Harris on 9/14/15.
//  Copyright © 2015 Tim Harris. All rights reserved.
//

import Foundation

class Server {
    var name:String
    var address:NSURL
    var port:Int
    
    init(aName:String, anAddress:NSURL, aPort:Int){
        name = aName
        address = anAddress
        port = aPort
    }
}