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
internal class AICustomAudioNotesView : UIView,AVAudioRecorderDelegate{
  // MARK: -
  // MARK: Internal access (aka public for current module)
  // MARK: -
    
    // MARK: -> Internal class
    
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var audioButton: DesignableButton!
    @IBOutlet weak var inputText: DesignableTextField!
    @IBOutlet weak var changeButton: DesignableButton!
    
    // MARK: -> Internal property
    private weak var recorder : AVAudioRecorder?
    private var lowPassResults: Double = 0
    private var timer: NSTimer?
    private var currentAudioState: Bool = false
    weak var delegateAudio:AICustomAudioNotesViewDelegate?
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
            let recorderSettingsDict = [
                AVFormatIDKey:NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
                AVSampleRateKey:44100.0,
                AVNumberOfChannelsKey:2,
                AVLinearPCMBitDepthKey:8,
                AVLinearPCMIsBigEndianKey:false,
                AVLinearPCMIsFloatKey:false,
                AVEncoderBitRateKey : 320000]
            
            
            let fileName = getAudioFileName()
            currentAutioUrl = fileName
            recorder = try AVAudioRecorder(URL: NSURL(string: fileName)!, settings: recorderSettingsDict)
            
            print(fileName)
            if let _ = recorder {
                
                AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                    
                    print("录音权限查询结果： \(granted)")
                    do{
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                        try AVAudioSession.sharedInstance().setActive(true)
                    }catch{
                    }
                    
                    //开始录音..
                    self.recorder!.delegate = self
                    self.recorder!.meteringEnabled = true
                    self.recorder!.prepareToRecord()
                    self.recorder!.record()
                    
                    self.timer = NSTimer(timeInterval: 0.1, target: self, selector: "levelTimer:", userInfo: nil, repeats: true)
                    NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
                })
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
    
    /// MARK:  Finish Audio..
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        let data = NSData(contentsOfFile: currentAutioUrl) 
        if data != nil {
            
            let audioLength: Int = data!.length/1024/25
            let model = AIProposalHopeAudioTextModel()
            model.audio_url = currentAutioUrl
            model.audio_length = audioLength
            model.type = 0
            self.delegateAudio?.endRecording(model)
            
            /// 处理文件存储
            
            let videoFile = AVFile.fileWithName("\(NSDate().timeIntervalSince1970).aac", data:data) as! AVFile
            videoFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                print("saveInBackgroundWithBlock : \(videoFile.url)")
                
            })
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
        error: NSError?) {
            print("\(error!.localizedDescription)")
    }
    
    // MARK: -
    // MARK: Private access
    // MARK: -
    
    // MARK: -> Private methods

    @IBAction func touchUpAudioAction(sender: AnyObject) {
        if let rder = recorder {
            
            /// 松开 结束录音
            rder.stop()
            
            timer?.invalidate()
            timer = nil
            audioButton.setTitle("Hold to Talk", forState: UIControlState.Normal)
            
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
