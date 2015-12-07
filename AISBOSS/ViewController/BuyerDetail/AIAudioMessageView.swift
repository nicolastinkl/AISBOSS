//
//  AIAudioMessageView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring
import AIAlertView


@objc protocol AIAudioMessageViewDelegate : class{
    
    func willPlayRecording(audioMessageView :AIAudioMessageView)
    
    func didEndPlayRecording(audioMessageView :AIAudioMessageView)

}


class AIAudioMessageView: UIView,AVAudioPlayerDelegate {
    
    // MARK: currentView
    
    var toggle : Bool?
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var audioBg: DesignableLabel!
    @IBOutlet weak var audioGifImageView: UIImageView!
    @IBOutlet weak var audioLength: UILabel!
    @IBOutlet weak var playButton: UIButton!
    private var currentModelss:AIProposalHopeAudioTextModel?
    
    weak var delegate:AIAudioMessageViewDelegate?
    
    class func currentView()->AIAudioMessageView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioMessageView", owner: self, options: nil).first  as! AIAudioMessageView
        selfView.audioLength.font = AITools.myriadLightSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        return selfView
    }
    
    func fillData(model:AIProposalHopeAudioTextModel){
        self.audioLength.text = "\(model.audio_length)''"
        currentModelss = model
        self.configureAudio()
    }
    
    // MARK: 停止播放
    func stopPlay () {
        audioPlayer.stop()
        audioPlayer.delegate = nil
        audioGifImageView.stopAnimating()
        audioGifImageView.image = UIImage(named: "ai_audio_bg")
        
        delegate?.didEndPlayRecording(self)
    }
    
    // MARK: 配置
    
    func configureAudio () {
        
        do {
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)

        } catch {
            logInfo("AVAudioPlayer play failed error .. ")
            AIAlertView().showInfo("Player Error.", subTitle: "Info", closeButtonTitle: "close", duration: 3)
        }
        
        
        if (currentModelss!.audio_url == nil || currentModelss!.audio_url.length == 0) {
            currentModelss!.audio_url = "http://ac-xkz4nhs9.clouddn.com/lXoqWTK4pc4RcKjokfXcDgD.aac"
        }
        
        do {
            let url = NSURL(string: currentModelss!.audio_url)

            let data = NSData(contentsOfURL: url!)
            
            if (data != nil) {
                audioPlayer = try AVAudioPlayer(data: data!)
                
            }else {
                audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
            }
            
            audioPlayer.volume = 1.0

        }
        catch {
            logInfo("AVAudioPlayer play failed error .. ")
        }
    
    }
    
    
    
    func startPlay () {
        
        if audioPlayer == nil {
            return
        }

        if audioPlayer.playing {
            return
        }
        
        delegate?.willPlayRecording(self)
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    
    }
    
    
    
    @IBAction func playAction(sender: AnyObject) {
        Async.main(after: 0.1, block: { () -> Void in
            
            self.startPlay()
            
            //start playing gif Images
            let images = [UIImage(named: "ReceiverVoiceNodePlaying001")!,UIImage(named: "ReceiverVoiceNodePlaying002")!,UIImage(named: "ReceiverVoiceNodePlaying003")!]
            self.audioGifImageView.animationImages = images
            self.audioGifImageView.animationDuration = 0.8
            
            if (self.audioPlayer != nil) {
                self.audioGifImageView.startAnimating()
            }else{
                self.configureAudio()
                AIAlertView().showInfo("Get Record Error.", subTitle: "Info", closeButtonTitle: "close", duration: 3)
            }
            
            
            
        })

    }
    
    // MARK: Delegate...
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlay()
        logInfo("audioPlayerDidFinishPlaying")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        self.stopPlay()
        logInfo("audioPlayerDecodeErrorDidOccur error\(error?.description)")
    }
}