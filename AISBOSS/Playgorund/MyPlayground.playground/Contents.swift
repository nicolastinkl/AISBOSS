//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"



// Nullability and Objective-C between Swift.
/*
One of the great things about Swift is that it transparently inter operates with Objective-C code, both existing frameworks written in Objective-C and code in your app. However, in Swift there’s a strong distinction between optional and non-optional references, e.g. NSView vs. NSView?, while Objective-C represents boths of these two types as NSView *. Because the Swift compiler can’t be sure whether a particular NSView * is optional or not, the type is brought into Swift as an implicitly unwrapped optional, NSView!.

*/
let distinction = "区别"


// assert mentioned on page 55
assert(true)

assert(true, "error")


"error".characters.count //equel countElements.

for (i,j) in EnumerateSequence(["A","B","a"]){
        print("\(i):\(j)")
}


min(8, 2, 3) == 2

let newArray = ["B", "A","V","D"].sort { (a, b) -> Bool in
    return true
}

newArray

abs(-1) == 1
abs(-42) == 42
abs(42) == 42

var lanuages = ["swift","java"]

dump(lanuages)



var testArray:[Int] = [1,2,3]

let newArrayssss = testArray.map({return "NO.\($0)"})

newArrayssss




