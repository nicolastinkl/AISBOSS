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
    
    // MARK: -> Internal properties
    
    @IBOutlet weak var requireButton: UIButton!
    @IBOutlet weak var collaborationButton: UIButton!
    @IBOutlet weak var assignButton: UIButton!
    // MARK: -> Private type alias
    
    // MARK: -> Private methods
    
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
                print("")
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
