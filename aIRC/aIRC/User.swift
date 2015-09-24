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
    override init(){
        name = ""
        nickName = ""
    }
    init(aName:String, aNickname:String){
        name = aName
        nickName = aNickname
    }
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.nickName, forKey: "nickname")
    }
    @objc required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.nickName = aDecoder.decodeObjectForKey("nickname") as! String
    }
}