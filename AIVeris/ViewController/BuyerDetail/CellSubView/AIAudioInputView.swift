//
//  AIAudioInputView.swift
//  AIVeris
//
//  Created by tinkl on 14/12/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

// 新的语音实现界面

internal class AIAudioInputView:UIView,AVAudioRecorderDelegate{

    // MARK: Update
    let holdViewHeigh:CGFloat = 252.0
    
    private var currentAudioState: Bool = false
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeText: UILabel!
    
    @IBOutlet weak var changeButton: DesignableButton!
    
    @IBOutlet weak var textInput: DesignableTextField!
    
    @IBOutlet weak var audioButtonView: UIView!
    
    @IBOutlet weak var inputTextView: DesignableTextView!
    @IBOutlet weak var inputButtomValue: NSLayoutConstraint!
    
    // MARK: -> Internal property
    private var recorder : AVAudioRecorder? //这里不能够weak
    private var lowPassResults: Double = 0
    private var timer: NSTimer?
    private var audioTimes:Int = 0
    private var isCancalRecordMode: Bool = false
    @IBOutlet weak var audioButtonRecord: DesignableButton!
    
    var currentTime : NSTimeInterval?
    let maxRecordTime : NSTimeInterval = 60
    
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
    
    class func currentView()->AIAudioInputView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioInputView", owner: self, options: nil).first  as! AIAudioInputView
        selfView.timeText.font = AITools.myriadSemiCondensedWithSize(58/PurchasedViewDimention.CONVERT_FACTOR)
        selfView.timeText.textColor = UIColor(hex:"#6a6a6a")
        selfView.inputTextView.font = AITools.myriadSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)

        selfView.setNeedsUpdateConstraints()
        selfView.layoutIfNeeded()

        return selfView
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
                    
                    self.timer = NSTimer(timeInterval: 1, target: self, selector: "levelTimer:", userInfo: nil, repeats: true)
                    NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
                })
            }
        } catch {
            logInfo("startRecording error")
        }
    }
    
    //放弃录音
    @IBAction func cancelRecordAction(sender: AnyObject){
        isCancalRecordMode = true
        stopRecording()
    }
    
    /**
     - parameter time: 1s
     */
    func levelTimer(time : NSTimer){
        if let rder = recorder {
            // audioTimes ++
            audioTimes = audioTimes + 1
            
            if audioTimes < 10 {
                self.timeText.text = "0:0\(audioTimes)"
            }else if audioTimes >= 10 {
                self.timeText.text = "0:\(audioTimes)"
            }
            
            if (rder.currentTime >= maxRecordTime) {
                stopRecording()
            }
        }
    
    }
    
    @IBAction func touchDownAudio(sender: AnyObject) {
        
        startRecording()
        delegateAudio?.willStartRecording()
        self.timeText.text = "0:00"
    }
    
    func changeModel(type: Int){
        let bgImage:UIImage?
        if type == 0{
            //Audio Mode...
            bgImage = UIImage(named: "ai_keyboard_button_change")
            inputTextView.resignFirstResponder()
            currentAudioState  = false
        }else{
            //Text Mode...
            //文字模式
            bgImage = UIImage(named: "ai_audio_button_change")
            inputTextView.becomeFirstResponder()
            currentAudioState = true
        }
        if let m = bgImage {
            changeButton.setImage(m, forState: UIControlState.Normal)
        }
             
    }
    
    @IBAction func ChangeAction(sender: AnyObject) {
        currentAudioState = !currentAudioState
        //切换状态
        changeModel(Int(currentAudioState))
        
    }
    
    @IBAction func closeViewAction(sender: AnyObject) {
        self.delegateAudio?.cacheMessage(self.inputTextView.text)
        closeThisView()
    }
    
    internal func closeThisView(){
        SpringAnimation.springWithCompletion(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (complate) -> Void in
                self.removeFromSuperview()
        }
    }
    
    func notifyEndRecordWithUrl(url:String) {
        // fake
        let model = AIProposalServiceDetailHopeModel()
        model.audio_url = url
        model.time = (NSInteger)(currentTime! * 1000)
        model.type = "Voice"
        self.delegateAudio?.endRecording(model)
    }
    
    /// MARK:  Finish Audio ...
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if isCancalRecordMode {
            return
        }
        let data = NSData(contentsOfFile: currentAutioUrl)
        if data != nil {
            /// 处理文件存储
            
            self.audioButtonRecord.showProgressViewLoading()
            self.audioButtonRecord.enabled = false
            Async.background({ () -> Void in
                
                weak var weakSelf = self
                let videoFile = AVFile.fileWithName("\(NSDate().timeIntervalSince1970).aac", data:data) as! AVFile
                videoFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.audioButtonRecord.hideProgressViewLoading()
                    self.audioButtonRecord.enabled = true
                    
                    print("saveInBackgroundWithBlock : \(videoFile.url)")
                    weakSelf?.notifyEndRecordWithUrl(videoFile.url)
                    
                })
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
    
    func stopRecording () {
        if let rder = recorder {
            
            /// 松开 结束录音
            // 记录录音时间
            currentTime = rder.currentTime
            
            // 停止记录
            rder.stop()
            
            timer?.invalidate()
            timer = nil

            timeText.text = "AICustomAudioNotesView.hold".localized
            self.delegateAudio?.willEndRecording()
            logInfo("松开 结束录音")
        }
    }
    

    
    @IBAction func touchUpAudioAction(sender: AnyObject) {
        isCancalRecordMode = false
        if let _ = recorder {
            stopRecording()
            
        }else{
            
            timer?.invalidate()
            timer = nil
            let model = AIProposalServiceDetailHopeModel()
            model.audio_url = ""
            model.type = "Voice"
            self.delegateAudio?.endRecording(model)
        }
    }
}
