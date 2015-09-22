//
//  JumpNumberLabel.swift
//  JumpNumber
//
//  Created by Rocky on 15/9/18.
//

import UIKit

class JumpNumberLabel: UILabel {
    
    private static let DEFAULT_FLOAT_FORMAT = "%.2f"
    private static let DEFAULT_INT_FORMAT = "%d"
    private static let DEFAULT_DURATION: NSTimeInterval = 0.5
    
    private var defaultJumpCount = 10
    private var oldFloat: Float = 0
    private var currentNumber: Float = 0
    private var destinationFloat: Float!
    private var stepFloat: Float!
    private var oldNumber: NSNumber?
    private var flickerNumber: NSNumber!
    private var timer: NSTimer?
    private var changeTimeInterval: NSTimeInterval!
    private var isFloat: Bool!
    
    
    var formatFloatStr = DEFAULT_FLOAT_FORMAT
    var formatIntStr = DEFAULT_INT_FORMAT

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func changeFloatNumberTo(toNumber: Float, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_FLOAT_FORMAT) {
        changeFloatNumberFrom(currentNumber, toNumber: toNumber, duration: duration, format: format)
    }
    
    func changeFloatNumberFrom(fromNumber: Float, toNumber: Float, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_FLOAT_FORMAT) {
        currentNumber = fromNumber
        destinationFloat = toNumber
        changeTimeInterval = duration / Double(defaultJumpCount)
        formatFloatStr = format
        isFloat = true
        
        stepFloat = calculateStepNumber(destinationFloat - currentNumber, jumpCount: defaultJumpCount)
        
        startChangeFloat(duration)
    }
    
    func changeIntNumberTo(toNumber: Int, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_INT_FORMAT) {
        changeIntNumberFrom(Int(currentNumber), toNumber: toNumber, duration: duration, format: format)
    }
    
    func changeIntNumberFrom(fromNumber: Int, toNumber: Int, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_INT_FORMAT) {
        currentNumber = Float(fromNumber)
        destinationFloat = Float(toNumber)
        let realJumpCount = min(abs(toNumber - fromNumber), defaultJumpCount)
        changeTimeInterval = duration / Double(realJumpCount)
        formatIntStr = format
        isFloat = false
        
        stepFloat = calculateStepNumber(destinationFloat - currentNumber, jumpCount: realJumpCount)
        
        startChangeFloat(duration)
    }
    
    private func calculateStepNumber(numberRange: Float, jumpCount: Int) -> Float {
        return numberRange / Float(jumpCount)
    }
    
    private func startChangeFloat(duration: NSTimeInterval) {
        timer = NSTimer.scheduledTimerWithTimeInterval(changeTimeInterval, target: self, selector: "decideNextStep:", userInfo: nil, repeats: true)
    }
    
    func decideNextStep(timer: NSTimer) {
        currentNumber += stepFloat
        
        if (currentNumberIsBeyondRange()) {
            stopChange()
        } else {
            continueChange()
        }
        
        setTextResult()
    }
    
    private func currentNumberIsBeyondRange() -> Bool {
        if (stepFloat > 0) {
            return currentNumber > destinationFloat
        } else {
            return currentNumber < destinationFloat
        }
    }
    
    private func stopChange() {
        timer?.invalidate()
        currentNumber = destinationFloat
    }
    
    private func continueChange() {
        
    }
    
    private func setTextResult() {
        let outputStr = (isFloat == true) ? NSString(format: formatFloatStr, currentNumber) : NSString(format: formatIntStr, Int(currentNumber + 0.5))
        text = outputStr as String
    }

}
