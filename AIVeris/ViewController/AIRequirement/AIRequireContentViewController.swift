//
//  AIRequireContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIRequireContentViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    private var dataSource : [AIContentCellModel]? = {
    
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
        
        var c2 = AIChildContentCellModel()
        c2.id = 1
        c2.type = 2
        c2.bgImageUrl = ""
        c2.text = "Accompany and attend to Accompany and attend"
        
        conModel.childServices = [c1,c2]
        
        
        var msgModel = AIContentCellModel()
        msgModel.id = 13
        msgModel.type = 2
        msgModel.typeImageUrl = "user-message-0"
        msgModel.typeName = "user message"
        
        var c3 = AIChildContentCellModel()
        c3.id = 1
        c3.type = 3
        c3.bgImageUrl = ""
        c3.text = "Body is weak,can not cary heavy , pay attention to nuturetion collocation. Accompany and attend to Accompany and attend"
        
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
        
        dataModel.childServices = [c2,c3,c4]
        
        
        return [conModel,msgModel,dataModel]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.estimatedRowHeight = UITableViewAutomaticDimension
        
        
    }
    
}


extension AIRequireContentViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
            //其它均是内容cell            
            let contentModel : AIChildContentCellModel = (currentCellModel?.childServices?[indexPath.row-1])!
            let CELL_ID = "Cell_\(currentCellModel?.id ?? 0 )_\(contentModel.id ?? 0)" //作为唯一ID防止数据乱套
            
            var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) as? SESlideTableViewCell
            if cell == nil {
                cell = SESlideTableViewCell(style: .Default, reuseIdentifier: CELL_ID)
                cell!.selectionStyle = .None
                cell!.delegate = self
                cell!.backgroundColor = UIColor.clearColor()
                
                switch contentModel.type ?? 0 {
                case 0 :
                    print("")
                case 1:
                    print("")
                default:
                    break
                }
                
                cell?.textLabel?.text = contentModel.text ?? ""
                
                
                cell!.addRightButtonWithImage(UIImage(named: "AIROAddNote"), backgroundColor: UIColor(hexString: "#0B1051"))
                
                cell!.addLeftButtonWithImage(UIImage(named: "AIROAddTag"), backgroundColor: UIColor(hexString: "#0D0F51"))
                cell!.addLeftButtonWithImage(UIImage(named: "AIROAddNote"), backgroundColor: UIColor(hexString: "#1C2071"))
                cell!.addLeftButtonWithImage(UIImage(named: "AIROAddTask"), backgroundColor: UIColor(hexString: "#1E2089"))
                
                
            }
            cell!.showsLeftSlideIndicator = true
            cell!.showsRightSlideIndicator = true
            
            return cell!
        }
        
    }
}

extension AIRequireContentViewController : SESlideTableViewCellDelegate{
    
}



