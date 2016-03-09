//
//  AIRequireContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SnapKit

class AIRequireContentViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    private var dataSource : [AIContentCellModel]? = {
    
        
        var i1 = AIIconTagModel()
        i1.iconUrl = "http://171.221.254.231:3000/upload/proposal/3e7Sx8n4vozQj.png"
        
        var i2 = AIIconTagModel()
        i2.iconUrl = "http://171.221.254.231:3000/upload/proposal/LATsJIV2vKdgp.png"
        
        var i3 = AIIconTagModel()
        i3.iconUrl = "http://171.221.254.231:3000/upload/proposal/EZwliZwHINGpm.png"
        
        var conModel = AIContentCellModel()
        conModel.id = 12
        conModel.type = 1
        conModel.typeImageUrl = "user-note--0"
        conModel.typeName = "user note"
        
        var c1 = AIChildContentCellModel()
        c1.id = 1
        c1.type = 1
        c1.bgImageUrl = ""
        c1.text = "9 weeks of pregnancy, action ooooo"
        c1.childServerIconArray = [i1,i2,i3]
        
        var c2 = AIChildContentCellModel()
        c2.id = 1
        c2.type = 2
        c2.bgImageUrl = ""
        c2.text = "Accompany and attend to Accompany and attend"
        c2.childServerIconArray = [i1,i2,i3]
        
        conModel.childServices = [c1,c2]
        
        
        var msgModel = AIContentCellModel()
        msgModel.id = 13
        msgModel.type = 2
        msgModel.typeImageUrl = "user-message-0"
        msgModel.typeName = "user message"
        
        var c3 = AIChildContentCellModel()
        c3.id = 1
        c3.type = 1
        c3.bgImageUrl = ""
        c3.text = "Body is weak,can not cary heavy , pay attention to nuturetion collocation. Accompany and attend to Accompany and attend"
        c3.childServerIconArray = [i1,i2,i3]
        msgModel.childServices = [c3]
        
        
        var dataModel = AIContentCellModel()
        dataModel.id = 14
        dataModel.type = 3
        dataModel.typeImageUrl = "user-data-0"
        dataModel.typeName = "user data"
        
        var c4 = AIChildContentCellModel()
        c4.id = 1
        c4.type = 4
        c4.bgImageUrl = ""
        c4.text = "Fasting blood glucos : 6MM mol /ml."
        c4.content = "Anysls sadjlkfjaskldfjkl;asjf;ljkasdjfkl;dafjadsklf;a"
        c4.childServerIconArray = [i1,i2,i3]
        dataModel.childServices = [c2,c3,c4]
        
        return [conModel,msgModel,dataModel]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.estimatedRowHeight = 140
        tableview.rowHeight = UITableViewAutomaticDimension
        
        // Reloading for the visible cells to layout correctly
        Async.main { () -> Void in
            self.tableview.reloadData()
        }
        
    }
    
}

extension AIRequireContentViewController : UITableViewDelegate,UITableViewDataSource {
    
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // expend or coll current cell.
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = dataSource?[section].childServices?.count ?? 0
        return rows + 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCellModel = dataSource?[indexPath.section]
        if indexPath.row == 0 {
            //第一行就是标题cell处理
            let cell = tableView.dequeueReusableCellWithIdentifier("cellTitleIDentity")
            let signImgView = cell?.contentView.viewWithTag(3) as! UIImageView
            let signTextView = cell?.contentView.viewWithTag(2) as! UILabel
            
            signImgView.image = UIImage(named: currentCellModel?.typeImageUrl ?? "")
            signTextView.text = currentCellModel?.typeName ?? ""
            signTextView.textColor = UIColor(hexString: "ffffff", alpha: 0.75)
            signTextView.font = AITools.myriadLightSemiExtendedWithSize(14)
            
            return cell!
            
        }else{
            // Content Cell  Info.
            let contentModel : AIChildContentCellModel = (currentCellModel?.childServices?[indexPath.row-1])!
            // Cache Cell...
            let CELL_ID = "Cell_\(currentCellModel?.id ?? 0 )_\(contentModel.id ?? 0)"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) as? SESlideTableViewCell
            if cell == nil {
                cell = SESlideTableViewCell(style: .Default, reuseIdentifier: CELL_ID)
                cell!.selectionStyle = .None
                cell!.delegate = self
                cell!.backgroundColor = UIColor.clearColor()
                if let cell = cell {
                    configureCell(cell, atIndexPath:indexPath, contentModel:contentModel)
                }
            }
            
            cell!.showsLeftSlideIndicator = false
            cell!.showsRightSlideIndicator = false
            
            // In order to make sure the cell have correct size while dequeuing,
            // manually set the frame to it's parent's bounds
            cell!.frame = tableview.bounds
            
            return cell!
        }
        
    }
    
    func reloadRowAtIndexPath(indexPath: NSIndexPath) {
        tableview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: Misc
    
    func configureCell(cell:SESlideTableViewCell, atIndexPath indexPath:NSIndexPath, contentModel : AIChildContentCellModel) {

        let contentView = AIRACContentView.currentView()
        
        cell.contentView.addSubview(contentView)
        contentView.snp_makeConstraints(closure: { (make) -> Void in
            make.margins.equalTo(cell.contentView)
        })
        
        var imageName = "ai_rac_bg_normal"
        switch contentModel.type ?? 0 {
        case 1 :
            imageName = "ai_rac_bg_normal_pop"
        case 2:
            imageName = "ai_rac_bg_normal"
        case 3:
            imageName = "ai_rac_bg_normal1"
        case 4:
            imageName = "ai_rac_bg_normal2"
        default:
            break
        }
        
        contentView.bgImageView.image = UIImage(named: imageName)
                
        contentView.tiitleLabel.text = contentModel.text ?? ""
        
        cell.addRightButtonWithImage(UIImage(named: "AIROAddNote"), backgroundColor: UIColor(hexString: "#0B1051"))
        
        cell.addLeftButtonWithImage(UIImage(named: "AIROAddTag"), backgroundColor: UIColor(hexString: "#0D0F51"))
        cell.addLeftButtonWithImage(UIImage(named: "AIROAddNote"), backgroundColor: UIColor(hexString: "#1C2071"))
        cell.addLeftButtonWithImage(UIImage(named: "AIROAddTask"), backgroundColor: UIColor(hexString: "#1E2089"))
        
    }
}

// MARK: - Cell Call back Event.
extension AIRequireContentViewController : SESlideTableViewCellDelegate{
    
    func slideTableViewCell(cell: SESlideTableViewCell!, canSlideToState slideState: SESlideTableViewCellSlideState) -> Bool {
        return true
    }
    
    func slideTableViewCell(cell: SESlideTableViewCell!, didSlideToState slideState: SESlideTableViewCellSlideState) {
        
    }
    
    func slideTableViewCell(cell: SESlideTableViewCell!, didTriggerLeftButton buttonIndex: Int) {
        
    }
    
    func slideTableViewCell(cell: SESlideTableViewCell!, didTriggerRightButton buttonIndex: Int) {
        
    }
    
    func slideTableViewCell(cell: SESlideTableViewCell!, willSlideToState slideState: SESlideTableViewCellSlideState) {
        
    }
    
    func slideTableViewCell(cell: SESlideTableViewCell!, wilShowButtonsOfSide side: SESlideTableViewCellSide) {       
        
    }
    
}



