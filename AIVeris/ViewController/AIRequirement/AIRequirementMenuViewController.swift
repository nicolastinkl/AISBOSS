//
//  AIRequirementMenuViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Base on Tof Templates
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

// MARK: -
// MARK: AIRequirementMenuViewController
// MARK: -
internal class AIRequirementMenuViewController : UIViewController  {
    
    // MARK: -> Internal structs
    
    // MARK: -> Internal class
    
    // MARK: -> Internal type alias
    
    // MARK: -> Internal static properties
    
    @IBOutlet weak var labelRequire: UILabel!
    
    @IBOutlet weak var assignLabel: UILabel!
    
    @IBOutlet weak var collLabel: UILabel!
    
    // MARK: -> Internal properties
    
    @IBOutlet weak var requireButton: UIButton!
    @IBOutlet weak var collaborationButton: UIButton!
    @IBOutlet weak var assignButton: UIButton!
    
    var serviceInstsView : AIVerticalScrollView!
    var models : [IconServiceIntModel]?
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {

        super.viewDidLoad() // .if this will error.
        
        // TODO: Init Veris Lable's Font and Size.
        
        func initFont(label : UILabel){
            label.font = AITools.myriadLightSemiCondensedWithSize(9)
            label.textColor = UIColor(hexString: "ffffff", alpha: 0.7)
        }
        
        initFont(labelRequire)
        initFont(collLabel)
        initFont(assignLabel)
        
        // Set Unread's view
        // Create your badge and add it as a subview to whatever view you want to badgify.
        
        
        buildServiceInstsView()
    }
    
    
    
    @IBAction func targetForRequirementAction(anyobj: AnyObject){
        
        let button = anyobj as! UIButton
        
        func selectButton(tag : Int){
            
            switch tag {
            case 1:
                requireButton.setImage(UIImage(named: "imcollable_selected"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe"), forState: UIControlState.Normal)
                serviceInstsView.hidden = true
            case 2:
                
                requireButton.setImage(UIImage(named: "imcollable"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink_selected"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe"), forState: UIControlState.Normal)
                serviceInstsView.hidden = true
            case 3:
                
                requireButton.setImage(UIImage(named: "imcollable"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe_selected"), forState: UIControlState.Normal)
                serviceInstsView.hidden = false
                
            default :

                break
            }
            
        }
        
        selectButton(button.tag)
        
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementViewControllerNotificationName, object: button.tag)
        
        //withSwitchProfessionVC(button.tag)
    }
    
    @IBAction func targetForTableViewSelectAction(anyobj: AnyObject){
        //withSwitchProfessionVC(4)
    }
    

}

extension AIRequirementMenuViewController : VerticalScrollViewDelegate{
    func buildServiceInstsView(){
        let frame = CGRect(x: 0, y: CGRectGetMaxY(collLabel.frame) + 10, width: 65, height: 360)
        serviceInstsView = AIVerticalScrollView(frame: frame)
        serviceInstsView.userInteractionEnabled = true
        serviceInstsView.myDelegate = self
        //选择服务执行的时候才展现
        serviceInstsView.hidden = true
        view.addSubview(serviceInstsView)
        
        loadData()
        serviceInstsView.loadData(models!)
    }
    
    func loadData(){
        models = [IconServiceIntModel(serviceInstId: 1, serviceIcon: "Seller_Warning", serviceInstStatus: 0, executeProgress: 2),
            IconServiceIntModel(serviceInstId: 1, serviceIcon: "Seller_Warning", serviceInstStatus: 0, executeProgress: 3),
            IconServiceIntModel(serviceInstId: 2, serviceIcon: "Seller_Warning", serviceInstStatus: 1, executeProgress: 4),
            IconServiceIntModel(serviceInstId: 3, serviceIcon: "Seller_Warning", serviceInstStatus: 1, executeProgress: 5),
            IconServiceIntModel(serviceInstId: 4, serviceIcon: "Seller_Warning", serviceInstStatus: 0, executeProgress: 6),
            IconServiceIntModel(serviceInstId: 5, serviceIcon: "Seller_Warning", serviceInstStatus: 1, executeProgress: 7),
            IconServiceIntModel(serviceInstId: 6, serviceIcon: "Seller_Warning", serviceInstStatus: 1, executeProgress: 8),
            IconServiceIntModel(serviceInstId: 7, serviceIcon: "Seller_Warning", serviceInstStatus: 0, executeProgress: 2),
            IconServiceIntModel(serviceInstId: 8, serviceIcon: "Seller_Warning", serviceInstStatus: 0, executeProgress: 2)]
        
        
    }
    
    func viewCellDidSelect(verticalScrollView : AIVerticalScrollView , index : Int , cellView : UIView){
        var message = ""
        
        for selectModel in verticalScrollView.getSelectedModels(){
            message += "\(selectModel.serviceInstId), "
        }
        let alert = UIAlertController(title: "info", message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
