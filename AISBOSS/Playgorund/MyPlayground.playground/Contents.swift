//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


extension String {
    var banana : String {
//        let shortName = String(self.characters.dropFirst(1))
//        return "\(self) \(self) Bo B\(shortName) Banana Fana Fo F\(shortName)"
        
        return " \(self.characters.first!)"
    }
}

let bananaName = "Jimmy".banana		// "Jimmy Jimmy Bo Bimmy Banana Fana Fo Fimmy"


var string:String? = "s"

if let s = string{
    s
}else{
    print("nil....", terminator: "")
}


//func myMethod() throw{
//    guard let s =  string else {
//        print("sd")
//    }
//}
//
//myMethod()

"sd".uppercaseString


let s1 = "abc"

s1

var s2 = s1

s2 = "123"

s2


