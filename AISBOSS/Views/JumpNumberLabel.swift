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
    private var step: Float!
    private var oldNumber: NSNumber?
    private var flickerNumber: NSNumber!
    private var timer: NSTimer?
    private var changeTimeInterval: NSTimeInterval!
    private var isFloat: Bool!
    private var decimalFormat: NSNumberFormatter?
    
    
    var formatFloatStr = DEFAULT_FLOAT_FORMAT
    var formatIntStr = DEFAULT_INT_FORMAT
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func prepareView() {
        
    }
    
    func changeFloatNumberTo(toNumber: Float, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_FLOAT_FORMAT, numberFormat: NSNumberFormatter? = nil) {
        changeFloatNumberFrom(currentNumber, toNumber: toNumber, duration: duration, format: format, numberFormat: numberFormat)
    }
    
    func changeFloatNumberFrom(fromNumber: Float, toNumber: Float, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_FLOAT_FORMAT, numberFormat: NSNumberFormatter? = nil) {
        
        setParas(fromNumber, toNumber: toNumber, changeTimeInterval: duration / Double(defaultJumpCount), format: format, numberFormat: numberFormat, isFloat: true)
        
        step = calculateStepNumber(destinationFloat - currentNumber, jumpCount: defaultJumpCount)
        
        startChangeFloat(duration)
    }
    
    func changeIntNumberTo(toNumber: Int, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_INT_FORMAT, numberFormat: NSNumberFormatter? = nil) {
        changeIntNumberFrom(Int(currentNumber), toNumber: toNumber, duration: duration, format: format, numberFormat: numberFormat)
    }
    
    func changeIntNumberFrom(fromNumber: Int, toNumber: Int, duration: NSTimeInterval = DEFAULT_DURATION, format: String = DEFAULT_INT_FORMAT, numberFormat: NSNumberFormatter? = nil) {
        
        let realJumpCount = min(abs(toNumber - fromNumber), defaultJumpCount)
        
        setParas(Float(fromNumber), toNumber: Float(toNumber), changeTimeInterval: duration / Double(realJumpCount), format: format, numberFormat: numberFormat, isFloat: false)
        
        step = calculateStepNumber(destinationFloat - currentNumber, jumpCount: realJumpCount)
        
        startChangeFloat(duration)
    }
    
    private func setParas(fromNumber: Float, toNumber: Float, changeTimeInterval: NSTimeInterval, format: String, numberFormat: NSNumberFormatter?, isFloat: Bool) {
        self.currentNumber = fromNumber
        self.destinationFloat = toNumber
        self.changeTimeInterval = changeTimeInterval
        self.decimalFormat = numberFormat
        self.isFloat = isFloat
        
        if isFloat {
            self.formatFloatStr = format
        } else {
            self.formatIntStr = format
        }
    }
    
    static func createDefaultFloatCurrencyFormatter() -> NSNumberFormatter {
        return createDefaultCurrencyFormatter("###,##0.00")
    }
    
    static func createDefaultIntCurrencyFormatter() -> NSNumberFormatter {
        return createDefaultCurrencyFormatter("###,##0")

    }
    
    private static func createDefaultCurrencyFormatter(positiveFormat: String) -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.positiveFormat = positiveFormat
        return formatter
    }
    
    private func calculateStepNumber(numberRange: Float, jumpCount: Int) -> Float {
        return numberRange / Float(jumpCount)
    }
    
    private func startChangeFloat(duration: NSTimeInterval) {
        timer = NSTimer.scheduledTimerWithTimeInterval(changeTimeInterval, target: self, selector: "decideNextStep:", userInfo: nil, repeats: true)
    }
    
    func decideNextStep(timer: NSTimer) {
        currentNumber += step
        
        if (currentNumberIsBeyondRange()) {
            stopChange()
        } else {
            continueChange()
        }
        
        setTextResult()
    }
    
    private func currentNumberIsBeyondRange() -> Bool {
        if (step > 0) {
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
        
        var outStr: NSString?
        
        if isFloat == true {
            outStr = convertToFloatOutputString()
        } else {
            outStr = convertToIntOutputString()
        }
        
        text = outStr as? String
        
    }
    
    private func convertToFloatOutputString() -> NSString? {
        var outStr: NSString?
        if let numberFormatter = decimalFormat {
            if let str = numberFormatter.stringFromNumber(NSNumber(float: currentNumber)) {
                outStr = NSString(format: formatFloatStr, str)
            }
        } else {
            outStr = NSString(format: formatFloatStr, currentNumber)
        }
        
        return outStr
    }
    
    private func convertToIntOutputString() -> NSString? {
        var outStr: NSString?
        if let numberFormatter = decimalFormat {
            if let str = numberFormatter.stringFromNumber(NSNumber(long: Int(currentNumber + 0.5))) {
                outStr = NSString(format: formatIntStr, str)
            }
        } else {
            outStr = NSString(format: formatIntStr, Int(currentNumber + 0.5))
        }
        
        return outStr
    }
    
}
