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

class AIAudioMessageView: UIView,AVAudioPlayerDelegate {
    
    // MARK: currentView
    
    @IBOutlet weak var audioBg: DesignableLabel!
    @IBOutlet weak var audioGifImageView: UIImageView!
    @IBOutlet weak var audioLength: UILabel!
    @IBOutlet weak var playButton: UIButton!
    private var currentModelss:AIProposalHopeAudioTextModel?
    
    class func currentView()->AIAudioMessageView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioMessageView", owner: self, options: nil).first  as! AIAudioMessageView
        selfView.audioLength.font = AITools.myriadLightSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        return selfView
    }
    
    func fillData(model:AIProposalHopeAudioTextModel){
        self.audioLength.text = "\(model.audio_length)''"
        currentModelss = model
    }
    
    @IBAction func playAction(sender: AnyObject) {
        if let model = currentModelss{
            do{
               let player = try AVAudioPlayer(contentsOfURL: NSURL(string: model.audio_url)!)
                player.delegate = self
                player.prepareToPlay()
                player.play()
                
                //start playing gif Images
                let images = [UIImage(named: "ReceiverVoiceNodePlaying001")!,UIImage(named: "ReceiverVoiceNodePlaying002")!,UIImage(named: "ReceiverVoiceNodePlaying003")!]
                self.audioGifImageView.animationImages = images
                self.audioGifImageView.animationDuration = 0.8
                self.audioGifImageView.startAnimating()
               
            }catch{
                logInfo("AVAudioPlayer play failed error .. ")
                
                AIAlertView().showInfo("Player Error.", subTitle: "", closeButtonTitle: "Info", duration: 3)
            }

            
            
        }
    }
    
    // MARK: Delegate...
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        self.audioGifImageView.stopAnimating()
        self.audioGifImageView.image = UIImage(named: "ai_audio_bg")
        logInfo("audioPlayerDidFinishPlaying")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        self.audioGifImageView.stopAnimating()
        self.audioGifImageView.image = UIImage(named: "ai_audio_bg")
        logInfo("audioPlayerDecodeErrorDidOccur error\(error?.description)")
    }
}