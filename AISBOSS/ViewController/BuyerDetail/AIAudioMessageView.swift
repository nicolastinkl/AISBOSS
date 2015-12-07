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
    
    weak var delegate:AIDeleteActionDelegate?
    
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
        
        let meunController = UIMenuController()
        meunController.setTargetRect(self.bounds, inView: self)
        
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
        delegate?.deleteAction(self)
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
    
    
    func fillData(model:AIProposalHopeAudioTextModel){
        self.audioLength.text = "\(model.audio_length)''"
        currentModelss = model
    }
    
    @IBAction func playAction(sender: AnyObject) {
        if let model = currentModelss{
            Async.main(after: 0.1, block: { () -> Void in
                
                do{
                    let player = AITools.playAccAudio(NSURL(string: model.audio_url)!)
                    if player != nil {
                        player.delegate = self
                    }
                    /*let player = try AVAudioPlayer(contentsOfURL: NSURL(string: model.audio_url)!)
                    player.delegate = self
                    player.prepareToPlay()
                    player.play()
                    */
                    
                    //start playing gif Images
                    let images = [UIImage(named: "ReceiverVoiceNodePlaying001")!,UIImage(named: "ReceiverVoiceNodePlaying002")!,UIImage(named: "ReceiverVoiceNodePlaying003")!]
                    self.audioGifImageView.animationImages = images
                    self.audioGifImageView.animationDuration = 0.8
                    self.audioGifImageView.startAnimating()
                    
                }catch{
                    logInfo("AVAudioPlayer play failed error .. ")
                    
                    AIAlertView().showInfo("Player Error.", subTitle: "Info", closeButtonTitle: "close", duration: 3)
                }
                
            })
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