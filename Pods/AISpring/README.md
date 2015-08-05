# AISpring
A library to simplify iOS animations in Swift



## Installation
Drop in the Spring folder to your Xcode project.

Or via CocoaPods:

```
use_frameworks!
pod 'AISpring', '~> 1.0.2'
```


## Usage with Storyboard
In Identity Inspector, connect the UIView to SpringView Class and set the animation properties in Attribute Inspector.

![](http://cl.ly/image/241o0G1G3S36/download/springsetup.jpg)

## Usage with Code
    layer.animation = "squeezeDown"
    layer.animate()

## Demo The Animations
![](http://cl.ly/image/1n1E2j3W3y24/springscreen.jpg)
 
## Chaining Animations
    layer.y = -50
    animateToNext {
      layer.animation = "fall"
      layer.animateTo()
    }
    
    
    
## CococaPods
![](http://tinkl.qiniudn.com/tinklUpload_7D7688ED-9D32-4462-8B65-981E17439F20.jpg)    