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
internal class AIRequirementMenuViewController : AIRequirementViewController,AIRequireProtocol {
    
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
    
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Init Veris Lable's Font and Size.
        
        func initFont(label : UILabel){
            label.font = AITools.myriadLightSemiCondensedWithSize(9)
            label.textColor = UIColor(hexString: "ffffff", alpha: 0.7)
        }
        
        initFont(labelRequire)
        initFont(collLabel)
        initFont(assignLabel)
        
        
        
    }
    
    
    @IBAction func targetForRequirementAction(anyobj: AnyObject){
        
        let button = anyobj as! UIButton
        
        func selectButton(tag : Int){
            
            switch tag {
            case 1:
                requireButton.setImage(UIImage(named: "imcollable_selected"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe"), forState: UIControlState.Normal)
                
            case 2:
                
                requireButton.setImage(UIImage(named: "imcollable"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink_selected"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe"), forState: UIControlState.Normal)
                
            case 3:
                
                requireButton.setImage(UIImage(named: "imcollable"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe_selected"), forState: UIControlState.Normal)
                
                
            default :

                break
            }
            
        }
        
        selectButton(button.tag)
        
        withSwitchProfessionVC(button.tag)
    }
    
    @IBAction func targetForTableViewSelectAction(anyobj: AnyObject){
        withSwitchProfessionVC(4)
    }
    

}
