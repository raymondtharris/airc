//
//  User.swift
//  aIRC
//
//  Created by Tim Harris on 9/20/15.
//  Copyright © 2015 Tim Harris. All rights reserved.
//

import Foundation

class User {
    var name: String
    var nickName: String
    init(){
        name = ""
        nickName = ""
    }
    init(aName:String, aNickname:String){
        name = aName
        nickName = aNickname
    }
}