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


class AIAudioMessageView: AIWishMessageView,AVAudioPlayerDelegate {
    
    // MARK: currentView
    
    var toggle : Bool?
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var audioBg: DesignableLabel!
    @IBOutlet weak var audioGifImageView: UIImageView!
    @IBOutlet weak var audioLength: UILabel!
    @IBOutlet weak var playButton: UIButton!
    private var currentModelss:AIProposalServiceDetailHopeModel?
    @IBOutlet weak var widthAudioBgConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    weak var audioDelegate:AIAudioMessageViewDelegate?

    weak var deleteDelegate:AIDeleteActionDelegate?

    var messageCache:AIMessage?
    
    class func currentView()->AIAudioMessageView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioMessageView", owner: self, options: nil).first  as! AIAudioMessageView
        selfView.audioLength.font = AITools.myriadLightSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        let longPressGes = UILongPressGestureRecognizer(target: selfView, action: "handleLongPress:")
        longPressGes.minimumPressDuration = 0.3
        selfView.addGestureRecognizer(longPressGes)
        
        return selfView
    }
    
    func handleLongPress(longPressRecognizer:UILongPressGestureRecognizer){
        
        if (longPressRecognizer.state != UIGestureRecognizerState.Began) {
            return;
        }
        
        if (becomeFirstResponder() == false) {
            return;
        }
        let point = longPressRecognizer.locationInView(self)
        
        let meunController = UIMenuController.sharedMenuController()
        
        let newBounds = CGRectMake(point.x, self.bounds.origin.y + 12, 50, self.bounds.height)        
        
        meunController.setTargetRect(newBounds, inView: self)
        
        let item = UIMenuItem(title: "Delete", action: "sendDeleteMenuItemPressed:")
        meunController.menuItems = [item]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillShow:", name: UIMenuControllerWillShowMenuNotification, object: nil)
        meunController.setMenuVisible(true, animated: true)
        
    }
    
    func menuWillShow(notification:NSNotification){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillShowMenuNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil)
    }
    
    func menuWillHide(notification:NSNotification){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillHideMenuNotification, object: nil)
    }
    
    func sendDeleteMenuItemPressed(menuController: UIMenuController){
        self.resignFirstResponder()
        deleteDelegate?.deleteAction(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.resignFirstResponder() == false {
            return
        }
        
        let menu =  UIMenuController.sharedMenuController()
        menu.setMenuVisible(false, animated: true)
        menu.update()
        self.resignFirstResponder()
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func becomeFirstResponder()->Bool{
        return super.becomeFirstResponder()
    }
    
    func fillData(model:AIProposalServiceDetailHopeModel){
        let length = (NSInteger)(model.time / 1000)
        self.audioLength.text = "\(length)''"
        currentModelss = model
       
        self.configureAudio()
        self.configureImages()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let model = currentModelss{
            
            let length = (NSInteger)(model.time / 1000)

            widthAudioBgConstraint.constant = 70 + 5.0 * CGFloat(length)
            
        }
    }
    
    // MARK: 停止播放
    func stopPlay () {
        audioPlayer.stop()
        audioPlayer.delegate = nil
        audioGifImageView.stopAnimating()
        audioGifImageView.image = UIImage(named: "ai_audio_bg")
        
        audioDelegate?.didEndPlayRecording(self)
    }
    
    // MARK: 配置
    
    func configureAudio () {
        
        do {
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)

        } catch {
            logInfo("AVAudioPlayer play failed error .. ")
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
    
    func configureImages () {
        let images = [UIImage(named: "ReceiverVoiceNodePlaying001")!,UIImage(named: "ReceiverVoiceNodePlaying002")!,UIImage(named: "ReceiverVoiceNodePlaying003")!]
        self.audioGifImageView.animationImages = images
        self.audioGifImageView.animationDuration = 0.8
    }
    
    func startPlay () {
        
        if audioPlayer == nil {
            return
        }

        if audioPlayer.playing {
            return
        }
        
        audioDelegate?.willPlayRecording(self)
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    
    }
     
    
    @IBAction func playAction(sender: AnyObject) {
        Async.main(after: 0.1, block: { () -> Void in
            
            
            //start playing gif Images
            if (self.audioPlayer != nil) {
                if self.audioPlayer.playing {
                    self.stopPlay()
                    
                }
                else {
                    self.startPlay()
                    self.audioGifImageView.startAnimating()
                }
                
            }else{
                self.configureAudio()
                AIAlertView().showInfo(AIAudioMessageView.kERROR, subTitle:AIAudioMessageView.kINFO, closeButtonTitle: AIAudioMessageView.kCLOSE, duration: 3)
            }

        })

    }
    
    @IBAction func retrySendRequest(sender: AnyObject) {
        self.loadingView.hidden = false
        self.loadingView.startAnimating()
        self.errorButton.hidden = true
        
        self.deleteDelegate?.retrySendRequestAction(self)
        
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

extension AIAudioMessageView {
    @nonobjc static let kERROR = "AILocalizationManager.error".localized
    @nonobjc static let kINFO = "AILocalizationManager.info".localized
    @nonobjc static let kCLOSE = "AILocalizationManager.close".localized
}
