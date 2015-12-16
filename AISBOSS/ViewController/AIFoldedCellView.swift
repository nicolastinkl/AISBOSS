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
    var proposalModel : ProposalOrderModel!

    // MARK: IBOutlets
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    var descContentView: AIOrderDescView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout{
            setLayout()
        }
    }
    
    func setLayout(){
        serviceNameLabel.font = PurchasedViewFont.TITLE
        statusLabel.font = PurchasedViewFont.STATU
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        
        descContentView = AIOrderDescView(frame: CGRectMake(0, 0, descView.bounds.width, descView.bounds.height))
        for serviceOrderModel : ServiceOrderModel in proposalModel.order_list as! [ServiceOrderModel]{
            if serviceOrderModel.order_state != "Completed" {
                descContentView?.loadData(serviceOrderModel)
            }
        }
        
        descView.addSubview(descContentView!)
        
        
        isFirstLayout = false
    }
    
    func loadData(proposalModel : ProposalOrderModel){
        self.proposalModel = proposalModel
        serviceNameLabel.text = proposalModel.proposal_name
        
        let firstServiceOrder : ServiceOrderModel? = proposalModel.order_list[0] as? ServiceOrderModel
        
        if let url = firstServiceOrder?.service_thumbnail_icon {
            
            serviceIcon.sd_setImageWithURL(url.toURL(), placeholderImage: UIImage(named: "Placehold"))
            
        }
        
        descContentView?.descLabel.text = firstServiceOrder?.service_name
        
        buildStatusData()
    }
    
    func buildStatusData(){
        //1: 正常 0:异常
        if proposalModel.alarm_state == 0 {
            alertIcon.hidden = false
            statusLabel.hidden = true
        } else {
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
    var model: ProposalOrderModel?
}
