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

@objc protocol AICustomAudioNotesViewDelegate : class{
    
    func updateMetersImage(lowPass:Double)
    func endRecording(audioModel:AIProposalServiceDetailHopeModel)
    func willStartRecording()
    
    func willEndRecording()
    func endRecordingWithError(error : String)
    
    func cacheMessage(message:String?)
    
}


@objc protocol AICustomAudioNotesViewShowAudioDelegate : class{
    func showAudioView(type:Int)  // 0 audio , 1 text
}
// MARK: -
// MARK: AICustomAudioNotesView
// MARK: -
internal class AICustomAudioNotesView : UIView,AVAudioRecorderDelegate{
  // MARK: -
  // MARK: Internal access (aka public for current module)
  // MARK: -
    
    // MARK: -> Internal class
    
    var currentTime : NSTimeInterval?
    let maxRecordTime : NSTimeInterval = 60
    
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var audioButton: DesignableButton!
    @IBOutlet weak var inputText: DesignableTextField!
    @IBOutlet weak var changeButton: DesignableButton!
    
    // MARK: -> Internal property
    private var recorder : AVAudioRecorder? //这里不能够weak
    private var lowPassResults: Double = 0
    private var timer: NSTimer?
    private var currentAudioState: Bool = false
    weak var delegateAudio:AICustomAudioNotesViewDelegate?
    weak var delegateShowAudio:AICustomAudioNotesViewShowAudioDelegate?
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
     
     - parameter time:
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
            // 如果录音长度超长，则停止录音
            
            if (rder.currentTime >= maxRecordTime) {
                stopRecording()
            }
            
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
        delegateAudio?.willStartRecording()
        audioButton.setTitle("AICustomAudioNotesView.release".localized, forState: UIControlState.Normal)
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
    
    
    func notifyEndRecordWithUrl(url:String) {
        
        let model = AIProposalServiceDetailHopeModel()
        model.audio_url = url
        model.time = (NSInteger)(currentTime! * 1000)
        model.type = "Voice";
        self.delegateAudio?.endRecording(model)
    }
    
    /// MARK:  Finish Audio..
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        let data = NSData(contentsOfFile: currentAutioUrl) 
        if data != nil {
            
            /// 处理文件存储
            weak var weakSelf = self
            let videoFile = AVFile.fileWithName("\(NSDate().timeIntervalSince1970).aac", data:data) as! AVFile
            videoFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                print("saveInBackgroundWithBlock : \(videoFile.url)")
                weakSelf?.notifyEndRecordWithUrl(videoFile.url)
            })
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
        error: NSError?) {
            
            self.delegateAudio?.endRecordingWithError(error!.localizedDescription)
            print("\(error!.localizedDescription)")
    }
    
    // MARK: -
    // MARK: Private access
    // MARK: -
    
    // MARK: -> Private methods
    
    @IBAction func touchUpShowAudioViewAction(sender: AnyObject) {
        self.delegateShowAudio?.showAudioView(0)
    }

    
    @IBAction func touchUpShowTextViewAction(sender: AnyObject) {
        self.delegateShowAudio?.showAudioView(1)
    }

    func stopRecording () {
        if let rder = recorder {
            
            /// 松开 结束录音
            // 记录录音时间
            currentTime = rder.currentTime
            
            // 停止记录
            rder.stop()
            
            timer?.invalidate()
            timer = nil
            audioButton.setTitle("AICustomAudioNotesView.hold".localized, forState: UIControlState.Normal)
            self.delegateAudio?.willEndRecording()
            logInfo("松开 结束录音")
        }
    }

    

    @IBAction func touchUpAudioAction(sender: AnyObject) {
        if let _ = recorder {
            
            /// 松开 结束录音
            stopRecording()
        }else{
            
            timer?.invalidate()
            timer = nil
            let model = AIProposalServiceDetailHopeModel()
            model.audio_url = ""
            model.time = 0
            model.type = "Voice"
            self.delegateAudio?.endRecording(model)
        }
    }
}

extension AICustomAudioNotesView: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.length < 198
        {
            return true
        }
        return false
    }
}

