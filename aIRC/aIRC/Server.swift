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
    var addedChannels:[Channel] = [Channel]()
    
    init(){
        name = ""
        address = NSURL(string: "")!
        port = 6667
    }
    
    init(aName:String, anAddress:NSURL, aPort:Int){
        name = aName
        address = anAddress
        port = aPort
    }
    
    func pushChannel(aChannel:Channel){
        addedChannels.append(aChannel)
    }
    
    func isValidServer() ->Bool {
        //connect to server. If connection is successful get server name and set it as name variable.
        if connect(){
            name = "Server C"
            return true
        }
        return false
    }
    
    func connect() -> Bool{
        return false
    }
    func disconnect(){
        
    }
}