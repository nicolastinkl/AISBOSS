//
//  AIScanViewController.swift
//  AITrans
//
//  Created by admin on 7/8/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import AIAlertView
import AISpring

class AIScanViewController: UIViewController {
    
    private var add = "add"
    private var delete = "delete"
    
    // MARK: - viewController variables
    @IBOutlet weak var label_Title: UILabel!
    
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var startLabel: UIImageView!
    
    @IBOutlet weak var endImage: DesignableLabel!
    // MARK: - variable
    
    private var currentLabelArray:Array<DesignableLabel>?
    
    private var currentPointImageView:NSMutableArray?
    
    //search view by liux
    private var serviceSearchView:AIServiceSearchView!
    
    private var curveView: CurveView?
    
    var varTitle:String?
    
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var revocationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    private var _editting:Bool = false
    
    private var _operationQueue:NSMutableArray?
    
    private var tagString:[String] = {
            return ["Indoor","Recycling","Interior","Whole house","Appliance","Room cleaning","Conditioning cleaning","ConditioningSS","ConditionSSing","CoSSnditioning","Swift"]
        }()
    
    private var temp:NSMutableArray = {
        NSMutableArray(objects: "1","3","5","7","9","2","4","6","8","0")
        }()
    
    private let tempHolderArray:NSMutableArray = NSMutableArray(objects: "1","3","5","7","9","2","4","6","8","0")
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label_Title.text  = varTitle ?? ""
        
        _operationQueue = NSMutableArray()
        
        //筛选所有label
        let array = self.view.subviews.filter({(view:AnyObject)->Bool in
            
            if view is DesignableLabel {
                if view.tag == 6 {
                    
                    return true
                }
            }
            return false
            
        })
        
        currentLabelArray = array as? [DesignableLabel]
        
        
        // nil
        //referesh()
        if UIScreen.mainScreen().bounds.width <= 320 {
            
            for label in currentLabelArray! {
                // Get Random Number..
                let someLabel = label as DesignableLabel
                
                someLabel.transform = CGAffineTransformMakeScale(0.7, 0.7)
                someLabel.hidden = true
                
            }
        }
        
        //init searchView
        serviceSearchView = AIServiceSearchView.currentView()
        serviceSearchView.setWidth(self.view.width)
        serviceSearchView.setHeight(self.view.height)
        serviceSearchView.setTop(self.view.height)
        serviceSearchView.alpha = 0
        serviceSearchView.searchDelegate = self
        self.view.addSubview(serviceSearchView)
        
        // Add Layer Round ..
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openAddViewNotification:", name: AIApplication.Notification.UIAIASINFOOpenAddViewNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openRemoveViewNotification:", name: AIApplication.Notification.UIAIASINFOOpenRemoveViewNotification, object: nil)
         
       
    }
    
    func openAddViewNotification(notify: NSNotification) {
        if let value = notify.object as! String?{
            addModel(value)
        }
        
    }
    
    func openRemoveViewNotification(notify: NSNotification) {
        if let value = notify.object as! String?{
            // remove
            
            self.curveView?.undoAddWithTitle(value)
            self.temp.removeLastObject()
        }
    }
    
    deinit{
        curveView = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.roundView.subviews.count > 0 {
            return
        }
        
        for delView in self.roundView.subviews as [UIView] {
            delView.removeFromSuperview()
        }
        
        
        // point's
        let arrayImageView = self.view.subviews.filter({(view:AnyObject)->Bool in
            
            if view is UIImageView {
                if view.tag == 13 {
                    return true
                }
            }
            return false
            
        })
        
        self.currentPointImageView = NSMutableArray(array: arrayImageView)
        
        for label in currentLabelArray! {
            // Get Random Number..
            let someLabel = label as DesignableLabel
            someLabel.hidden = true
        }
        
        
        
        /*
        for label in currentLabelArray! {
            // Get Random Number..
            let someLabel = label as DesignableLabel
            someLabel.hidden = true
            
        }
        
        func getRandomWidth() -> CGFloat{
            return CGFloat(arc4random()%60) + 20.0
        }
        
        func getRandomHeight() -> CGFloat{
            return CGFloat(arc4random()%30) + 30.0
        }
        
        func getRandomdisplayWidth() -> CGFloat{
            return CGFloat(arc4random()%30) + 50.0
        }
        
        
        */
        /*let mapping:CGFloat = getRandomWidth()
        let mappingX:CGFloat = getRandomHeight()
        // 1. 一象限
        if pointImageView.left > self.view.center.x && pointImageView.top > self.view.center.y {
        model.endX = pointImageView.left + mappingX
        model.endY = pointImageView.top + mapping
        // 2. 二象限
        }else if pointImageView.left < self.view.center.x && pointImageView.top > self.view.center.y {
        model.endX = pointImageView.left - mappingX
        model.endY = pointImageView.top + mapping
        // 3. 三象限
        }else if pointImageView.left < self.view.center.x && pointImageView.top < self.view.center.y {
        model.endX = pointImageView.left - mappingX
        model.endY = pointImageView.top - mapping
        // 4. 四象限
        }else if pointImageView.left > self.view.center.x && pointImageView.top < self.view.center.y {
        model.endX = pointImageView.left + mappingX
        model.endY = pointImageView.top - mapping
        }*/

        var modelArray = [CurveModel]()
        //这里是根据文字
        
        let tempArray = NSMutableArray(array: self.temp)
        let resultArray = NSMutableArray()
        let count = self.temp.count
        for i in 0...(count - 1) {
            
            let tempN = count - i
            
            //var index = Int(arc4random()%(UInt(tempN)))
            let index = Int(arc4random())%tempN
            //println("index: \(index)")
            resultArray.addObject(tempArray.objectAtIndex(index))
            let stringHere: AnyObject = tempArray.objectAtIndex(index)
            tempArray.removeObjectAtIndex(index)
            
            let stringHereInt = (stringHere as! String).toInt() ?? 0
            
            _ = self.tagString[stringHereInt]
            let pointImageView = self.currentPointImageView?.objectAtIndex(stringHereInt) as! UIImageView
            
            let hideLabel =  currentLabelArray![stringHereInt]
            let model = CurveModel()
            model.startX = pointImageView.left
            model.startY = pointImageView.top
            
            model.endX = hideLabel.left + 44
            model.endY = hideLabel.top + 5
            model.displayWidth = hideLabel.width
            model.strokeColor = UIColor.whiteColor()
            model.strokeWidth = 1
            let colorArray = ["#cb3061","#v65baf","#bac64d","#088f56","#1e68b6","#835bcc","#1db6c4","#ae387e","#2b89d2","#251E37","#1C1A30"]
            model.displayColor =  UIColor(rgba: colorArray[stringHereInt])
            model.animationDuration = 0.5
            
            model.displayTitle = self.tagString[stringHereInt]
            
            modelArray.append(model)
            
        }
         
        /*
        //这里是根据控件
        for pointImageView in arrayImageView as [UIImageView] {
            if currentLabelArray?.count > index{
                
                let hideLabel =  currentLabelArray![index] 
                var model = CurveModel()
                model.startX = pointImageView.left
                model.startY = pointImageView.top
                
                model.endX = hideLabel.left + 44
                model.endY = hideLabel.top + 5
                model.displayWidth = hideLabel.width
                model.strokeColor = UIColor.whiteColor()
                model.strokeWidth = 1
                let randomColor = Int(arc4random()%8)
                let colorArray = ["#cb3061","#v65baf","#bac64d","#088f56","#1e68b6","#835bcc","#1db6c4","#ae387e","#2b89d2"]
                model.displayColor =  UIColor(rgba: colorArray[randomColor])
                model.animationDuration = 0.5
                
                model.displayTitle = self.tagString[index]
                
                modelArray.append(model)
                
            }
            
            index += 1
        }*/
        var newFrame = self.roundView.frame
        newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y + 44)
        
        curveView = CurveView(frame: newFrame, points: modelArray)
        curveView?.delegate = self
        self.roundView.addSubview(curveView!)
        
        //curveView.backgroundColor = UIColor.redColor();

    }
    
    func loopSpring(views: [DesignableLabel]){

        var newViews = views
        if let label = newViews.first {
            springWithCompletion(0.6, animations: { () -> Void in
                label.alpha = 1
//                label.scaleX = 1.8
//                label.scaleY = 1.8
                label.animation = "zoomIn"
                label.duration = 1.0
                label.animate()
                }) { (complete) -> Void in
                    newViews.removeAtIndex(0)
                    self.loopSpring(newViews)
            }
        }
    }
    
    func referesh(){
        for label in currentLabelArray! {
            // Get Random Number..
            let someLabel = label as DesignableLabel
            someLabel.alpha = 0
            
        }
        
        loopSpring(currentLabelArray!)
    }
    
    // MARK: - Actions
    @IBAction func addAction(sender: AnyObject) {
        
        print(self.curveView?.bubbleCompareModels.allKeys.count)
        if self.curveView?.bubbleCompareModels.allKeys.count >= 10 {
            AIAlertView().showError("提示", subTitle: "不能超过10个颜色气泡", closeButtonTitle: "关闭", duration: 3)
            return
        }
        spring(0.7, animations: {
            self.serviceSearchView.setTop(0)
            self.serviceSearchView.alpha = 1
            })
        serviceSearchView.searchTextField.becomeFirstResponder()
        serviceSearchView.clearSearchResult()
        serviceSearchView.setInitViewAttr()
    }
    
    @IBAction func refereshAction(sender: AnyObject) {
        
        removeModel()
        
        // referesh...
        self.delButton.setImage(UIImage(named: "scan_delete"), forState: UIControlState.Normal)
    }
    
    @IBAction func deleteAction(sender: AnyObject)
    {
        // modelen
        
        let buttonDel = sender as! UIButton
        
        self.backButton.enabled = _editting
        self.revocationButton.enabled = _editting
        self.addButton.enabled = _editting
        
        
        _editting = !_editting
        
        
        if _editting {
            self.curveView?.startEdit()
            buttonDel.setImage(UIImage(named: "scan_delete_selected"), forState: UIControlState.Normal)
        }else{
            self.curveView?.endEdit()
            buttonDel.setImage(UIImage(named: "scan_delete"), forState: UIControlState.Normal)
        }
    }
    
    private func addModel(titleS:String){
        
       let newAry = curveView?.bubbleCompareModels.allKeys.filter({ (value) -> Bool in
            
                        if (value as! String) == titleS{
                            return true
                        }
                        return false
                    })
        if newAry?.count > 0 {
            return
        }
        
        let numberObj: AnyObject = self.tempHolderArray.objectAtIndex((self.temp.count-1))
        self.temp.addObject(numberObj)
        let stringHereInt = (numberObj as! String).toInt() ?? 0
        
        let pointImageView = self.currentPointImageView?.objectAtIndex(stringHereInt) as! UIImageView
        
        let hideLabel =  currentLabelArray![stringHereInt]
        let model = CurveModel()
        model.startX = pointImageView.left
        model.startY = pointImageView.top
        
        model.endX = hideLabel.left + 44
        model.endY = hideLabel.top + 5
        model.displayWidth = hideLabel.width
        model.strokeColor = UIColor.whiteColor()
        model.strokeWidth = 1
        let colorArray = ["#cb3061","#v65baf","#bac64d","#088f56","#1e68b6","#835bcc","#1db6c4","#ae387e","#2b89d2","#251E37","#1C1A30"]
        model.displayColor =  UIColor(rgba: colorArray[stringHereInt])
        model.animationDuration = 0.5
        
        model.displayTitle = titleS
        
        curveView?.addBubbleWithModel(model)
        
        _operationQueue?.addObject([add:model])
    }
    
    private func removeModel(){
        self.curveView?.endEdit()
        self.temp.removeLastObject()
        if  let modelLast: NSDictionary = _operationQueue?.lastObject as! NSDictionary?  {
            
            if let modelContent = modelLast.objectForKey(add) as! CurveModel? {
                curveView?.undoAddWithModel(modelContent)
            }
            
            if let modelContent = modelLast.objectForKey(delete) as! CurveModel? {
                curveView?.undoDeleteWithModel(modelContent)
                
            }
            
            _operationQueue?.removeLastObject()
        }
    }
    
    // MARK:  Delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let arrayKeys = self.curveView?.bubbleCompareModels.allKeys
        if segue.identifier == "SeeDetails" {
            let viewControoler = segue.destinationViewController as!AIServerDetailViewController
            viewControoler.titleString = self.label_Title.text
            viewControoler.titleArray = arrayKeys as! [String]?
            
        }
    }
    
    
}



extension AIScanViewController : serviceSearchViewDelegate,CurveViewDelegate {
    func complateWithTextView(text: String?) {
        if let modelTitle = text {
            addModel(modelTitle)
        }
    }
    
    func curveViewDidDeleteBubble(bubbleModel: CurveModel!) {
        _operationQueue?.addObject([delete:bubbleModel])
        
    }
}