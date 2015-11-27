//
//  AICustomAudioNotesView.swift
//  AIVeris
//
//  Created by tinkl on 20/11/2015.
//  Base on Tof Templates
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring

protocol AICustomAudioNotesViewDelegate : class{
    func startRecording()
    func updateMetersImage(lowPass:Double)
    func endRecording(audioModel:AIProposalHopeAudioTextModel)
}
// MARK: -
// MARK: AICustomAudioNotesView
// MARK: -
internal class AICustomAudioNotesView : UIView{
  // MARK: -
  // MARK: Internal access (aka public for current module)
  // MARK: -
    
    // MARK: -> Internal class
    
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var audioButton: DesignableButton!
    @IBOutlet weak var inputText: DesignableTextField!
    @IBOutlet weak var changeButton: DesignableButton!
    
    // MARK: -> Internal property
    private var recorder : AVAudioRecorder?
    private var lowPassResults: Double = 0
    private var timer: NSTimer?
    private var currentAudioState: Bool = false
    var delegateAudio:AICustomAudioNotesViewDelegate?
    internal var currentAutioUrl:String = ""
    
    func getAudioFileName() -> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let filename = Int(NSDate().timeIntervalSince1970)
        if let p = path {
            return "\(p)/\(filename).aac"
        }
        return ""
    }
    
    /**
     开始录音
     */
    func startRecording(){
        do {
            let recorderSettingsDict:[String:AnyObject] = [AVFormatIDKey:NSNumber(unsignedInt: kAudioFormatMPEG4AAC),AVSampleRateKey:NSNumber(float: 1000.0),AVNumberOfChannelsKey:NSNumber(int: 2),AVLinearPCMBitDepthKey:NSNumber(int: 8),AVLinearPCMIsBigEndianKey:NSNumber(bool: false),AVLinearPCMIsFloatKey:NSNumber(bool: false)]
            let fileName = getAudioFileName()
            currentAutioUrl = fileName
            recorder = try AVAudioRecorder(URL: NSURL(string: fileName)!, settings: recorderSettingsDict)
            
            print(fileName)
            if let rder = recorder {
                //开始录音..
                rder.meteringEnabled = true
                rder.prepareToRecord()
                rder.record()
                
                timer = NSTimer(timeInterval: 0.1, target: self, selector: "levelTimer:", userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
            }
        } catch {
            logInfo("startRecording error")
        }
    }
    
    /**
     刷新峰值
     
     - parameter time: <#time description#>
     */
    func levelTimer(time : NSTimer){
        if let rder = recorder {
            ///call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
            rder.updateMeters()
            let ALPHA : Double = 0.05
            let peakPowerForChannel : Double = pow(10, Double(0.05 * rder.peakPowerForChannel(0)))
            lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
            delegateAudio?.updateMetersImage(lowPassResults)
            //logInfo("Average input Low pass results: \(lowPassResults)")
        }
    }
    
    // MARK: currentView
    
    class func currentView()->AICustomAudioNotesView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AICustomAudioNotesView", owner: self, options: nil).first  as! AICustomAudioNotesView
        selfView.note.font = AITools.myriadSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        selfView.inputText.font = AITools.myriadSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        return selfView
    }
    
    // MARK: -> Internal methods
    
    @IBAction func touchDownAudio(sender: AnyObject) {
        
        startRecording()
        delegateAudio?.startRecording()
        audioButton.setTitle("Release to Send", forState: UIControlState.Normal)
    }
    
    @IBAction func changeAudioStatusAction(sender: AnyObject) {
        currentAudioState = !currentAudioState
        //切换状态
        
        let bgImage:UIImage?
        if currentAudioState {
            //语音模式
            bgImage = UIImage(named: "ai_keyboard_button_change")
            audioButton.hidden = false
            inputText.hidden = true
        }else{
            //文字模式
            bgImage = UIImage(named: "ai_audio_button_change")
            audioButton.hidden = true
            inputText.hidden = false
        }
        if let m = bgImage {
            changeButton.setImage(m, forState: UIControlState.Normal)
        }        
    }
    
    // MARK: -
    // MARK: Private access
    // MARK: -
    
    // MARK: -> Private methods

    @IBAction func touchUpAudioAction(sender: AnyObject) {
        if let rder = recorder {
            
            /// 处理文件存储
            
            /// 松开 结束录音
            rder.stop()
            
            timer?.invalidate()
            timer = nil
            audioButton.setTitle("Hold to Talk", forState: UIControlState.Normal)
            
            let data = NSData(contentsOfFile: currentAutioUrl) //NSURL(string: currentAutioUrl)!
            if data != nil {
                let videoFile = AVFile.fileWithName("\(NSDate().timeIntervalSince1970).aac", data:data) as! AVFile
                videoFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                    let size = videoFile.metaData.valueForKey("size") as! Int
                    let audioLength: Int = size/1024
                    
                    let model = AIProposalHopeAudioTextModel()
                    model.audio_url = videoFile.url
                    model.audio_length = audioLength
                    model.type = 0
                    self.delegateAudio?.endRecording(model)
                    
                })
                
            }
            recorder = nil
            logInfo("松开 结束录音")
        }else{
            
            timer?.invalidate()
            timer = nil
            let model = AIProposalHopeAudioTextModel()
            model.audio_url = ""
            model.audio_length = 0
            model.type = 0
            self.delegateAudio?.endRecording(model)
        }
        
    }
    
}
