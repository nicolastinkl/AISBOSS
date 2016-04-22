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


let im = UIImage(named: "ai_rac_bg_normal_pop")

let ss = im?.stretchableImageWithLeftCapWidth(0, topCapHeight: 12)

let imsss = UIImageView(frame: CGRectMake(0, 0, 400, 200))

imsss.image = ss




protocol ErrorPopoverRenderer {
    
    func  presentError(errorOptions: NSError)
}

//基于UIViewController
extension ErrorPopoverRenderer where Self : UIViewController {
    func presentError(errorOptions: NSError){
        // print("在这里加默认实现，并提供ErrorView的默认参数。")
    }
}


//基于UIView
extension ErrorPopoverRenderer where Self : UIView {
    func presentError(errorOptions: NSError){
        // print("在这里加默认实现，并提供ErrorView的默认参数。")
    }
}

//基于UIView
extension ErrorPopoverRenderer where Self : TinklView {
    func presentError(errorOptions: NSError){
        print(someProp)
        // print("在这里加默认实现，并提供ErrorView的默认参数。")
    }
}


class TinklViewController: UIViewController, ErrorPopoverRenderer {
    
    func failedToEatHuman() {
        //抛出error
        presentError(NSError(domain: "asiainfo.com/userinfo/get", code: 0, userInfo: nil))
    }
}

class TinklView : UIView, ErrorPopoverRenderer {
    var someProp: String = "string"
    func failedToEatHuman() {
        //抛出error
        presentError(NSError(domain: "asiainfo.com/userinfo/get", code: 1, userInfo: nil))
    }
}


protocol Hello{
    func sayHello()
}

extension Hello{
    func sayHello(){
        print("hello")
    }
}

class people : Hello {
    
}

people().sayHello()


func sayHello() {
    print("people say hello")
}



protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
typealias nameAgaProtocol = protocol<Named, Aged>
func wishHappyBirthday(celebrator: nameAgaProtocol) {
    print("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(birthdayPerson)





////MVVM:
//class Brew {
//    var temp: Float = 0.0
//}
//
//class BrewViewModel : NSObject {
//    var brew = Brew()
//    dynamic var temp: Float = 0.0 {
//        didSet {
//            self.brew.temp = temp
//        }
//    }
//    
//    override init() {
//        super.init()
//        self.connectToHost()
//    }
//    
//    func connectToHost() {
//        SIOSocket.socketWithHost("http://brewcore-demo.herokuapp.com", response: {socket in
//            socket.on("temperature_changed", callback: {(AnyObject data) -> Void in
//                self.temp = data[0] as Float
//            })
//        })
//    }
//    
//}
//
//class BrewViewController: UIViewController {
//    @IBOutlet weak var tempLabel: UILabel!
//    let brewViewModel = BrewViewModel()
//    
//    private var brewContext = 0
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.brewViewModel.addObserver(self, forKeyPath: "temp", options: .New, context: &brewContext)
//    }
//    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if context == &brewContext {
//            dispatch_async(dispatch_get_main_queue(), {
//                self.updateTempLabel((change[NSKeyValueChangeNewKey]) as Float)
//            })
//        } else {
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        }
//    }
//    
//    func updateTempLabel(temp: Float) {
//        self.tempLabel.text = NSString(format:"%.2f ˚C", temp)
//    }
//    
//}
//


let a: [Float] = [1, 2, 3, 4]
let b: [Float] = [0.5, 0.25, 0.125, 0.0625]
var result: [Float] = [0, 0, 0, 0]
 



class ClassA {
    let numA: Int
    required init(num: Int) {
        numA = num
    }
    
    convenience init(bigNum: Bool) {
        self.init(num: bigNum ? 10000 : 1)
    }
}

class ClassB: ClassA {
    let numB: Int
    
    required init(num: Int) {
        numB = num + 1
        super.init(num: num)
    }
}


let cA = ClassA(num: 1)
cA.numA

ClassB(bigNum: false).numB



