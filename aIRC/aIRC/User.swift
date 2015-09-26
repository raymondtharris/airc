//
//  User.swift
//  aIRC
//
//  Created by Tim Harris on 9/20/15.
//  Copyright © 2015 Tim Harris. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var name: String
    var nickName: String
    override var description: String{
        return "\(name) \(nickName)"
    }
    override init(){
        name = ""
        nickName = ""
    }
    init(aName:String, aNickname:String){
        name = aName
        nickName = aNickname
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(nickName, forKey: "nickname")
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.nickName = aDecoder.decodeObjectForKey("nickname") as! String
    }
}