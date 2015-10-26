//
//  FolderCellView.swift
//  NestedTableViewDemo
//
//  Created by 刘先 on 15/10/20.
//  Copyright © 2015年 wantsor. All rights reserved.
//

import UIKit

class AIFolderCellView: UIView {
    
    var isFirstLayout = true
    var proposalModel : ProposalModel!

    // MARK: IBOutlets
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout{
            setLayout()
        }
    }
    
    func setLayout(){
        let descContentView = AIOrderDescView(frame: CGRectMake(0, 0, descView.bounds.width, descView.bounds.height))
        self.descView.addSubview(descContentView)
        self.statusLabel.layer.cornerRadius = 8
        self.statusLabel.clipsToBounds = true
        
        //serviceNameLabel.font = AITools.myriadBoldWithSize(20)
        statusLabel.font = AITools.myriadLightSemiCondensedWithSize(13)
        isFirstLayout = false
    }
    
    func loadData(proposalModel : ProposalModel){
        self.proposalModel = proposalModel
        serviceNameLabel.text = proposalModel.proposal_name
        if let url = proposalModel.order_list[0].service_thumbnail_icon{
            serviceIcon.sd_setImageWithURL(url.toURL(), placeholderImage: UIImage(named: "Placehold"))
            
        }
        
        buildStatusData()
    }
    
    func buildStatusData(){
        //1: 正常 0:异常
        if proposalModel.alarm_state == 0{
            alertIcon.hidden = false
            statusLabel.hidden = true
        }
        else{
            alertIcon.hidden = true
            statusLabel.hidden = false
        }
    }
    
    // MARK: currentView
    class func currentView()->AIFolderCellView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIFoldedCellView", owner: self, options: nil).first  as! AIFolderCellView
        return selfView
    }

}

struct ProposalOrderModelWrap {
    var proposalId : Int?
    var isExpanded : Bool = false
    var expandHeight : CGFloat?
    var model: ProposalModel?
}
