//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"



dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
    print("This is run on the background queue")
    
    dispatch_async(dispatch_get_main_queue(), {
        print("This is run on the main queue, after the previous block")
    })
})






