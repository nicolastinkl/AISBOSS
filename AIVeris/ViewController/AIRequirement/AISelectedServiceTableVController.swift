//
//  AISelectedServiceTableVController.swift
//  AIVeris
//
//  Created by tinkl on 3/23/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
import AIAlertView

protocol AISelectedServiceTableVControllerDelegate: class {
    func refereshCell(cell: AIRACContentCell,contentModel: [AIIconTagModel]?)
}

class AISelectedServiceTableVController: UIViewController {

    var sourceDelegate = AIRACClosureTableViewDataSource()
    
    private let stableCellHeight: Int = 52
    
    var childModel: AIChildContentCellModel?
    
    var contentModel: AIContentCellModel?
    
    var preCell:AIRACContentCell?
    
    weak var delegate: AISelectedServiceTableVControllerDelegate?
    
    private let borderOffset: Int = 10

    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        func configureExpend(count: Int){
            
            let expendView = UIView()
            view.addSubview(expendView)
            let bgImageView = UIImageView(image: UIImage(named: "AIRequirebg2"))
            expendView.addSubview(bgImageView)
            
            let tableHeight = stableCellHeight * count
            expendView.snp_makeConstraints { (make) -> Void in
                make.bottom.equalTo(borderOffset)
                make.trailing.leading.equalTo(0)
                make.height.equalTo(tableHeight+110)
            }
            
            bgImageView.snp_makeConstraints { (make) -> Void in
                make.bottom.equalTo(0)
                make.trailing.leading.equalTo(0)
                make.height.equalTo(self.view.snp_height)
            }
            
            expendView.layer.cornerRadius = 8
            expendView.layer.masksToBounds = true
            
            let stable = UITableView()
            expendView.addSubview(stable)
            
            let cancelButton = DesignableButton(type: UIButtonType.Custom)
            let distriButton = DesignableButton(type: UIButtonType.Custom)
            
            expendView.addSubview(cancelButton)
            expendView.addSubview(distriButton)
            
            cancelButton.backgroundColor = UIColor(hexString: "#3055ab")
            cancelButton.setTitle("cancel", forState: UIControlState.Normal)
            cancelButton.titleLabel?.textColor = UIColor.whiteColor()
            cancelButton.cornerRadius = 5
            cancelButton.alpha = 0.65
            cancelButton.titleLabel?.font = AITools.myriadSemiboldSemiCnWithSize(24)
            cancelButton.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(51)
                //make.width.greaterThanOrEqualTo(189)
                make.bottom.equalTo(-27)
                make.leading.equalTo(13)
            })
            
            distriButton.backgroundColor = UIColor(hexString: "#0D85E8")
            distriButton.titleLabel?.textColor = UIColor.whiteColor()
            distriButton.titleLabel?.font = AITools.myriadSemiboldSemiCnWithSize(24)
            distriButton.setTitle("  distribution", forState: UIControlState.Normal)
            distriButton.cornerRadius = 5
            distriButton.setImage(UIImage(named: "aiselectDistrButton"), forState: UIControlState.Normal)
            distriButton.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(cancelButton.snp_height)
                make.width.equalTo(cancelButton.snp_width)
                make.bottom.equalTo(cancelButton.snp_bottom)
                make.left.equalTo(cancelButton.snp_right).offset(7)
                make.trailing.equalTo(-13)
            })
            
            cancelButton.setHighlightedBackgroundImage()
            distriButton.setHighlightedBackgroundImage()
            
            cancelButton.addTarget(self, action: "calcelAction:", forControlEvents: UIControlEvents.TouchUpInside)
            distriButton.addTarget(self, action: "distriAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            stable.dataSource = self.sourceDelegate
            stable.delegate = self.sourceDelegate
            stable.backgroundColor = UIColor.clearColor()
            stable.separatorStyle = UITableViewCellSeparatorStyle.None
            stable.allowsMultipleSelection = true
            stable.scrollEnabled = false
            stable.snp_makeConstraints(closure: { (make) -> Void in
                make.bottom.equalTo(distriButton.snp_top).offset(-18)
                make.leading.equalTo(21)
                make.trailing.equalTo(-14)
                make.height.equalTo(tableHeight)
            })
            stable.reloadData()
            
        }
        
        // Dosome network to request arrays data.
        
        let arrayAIServiceProvider = AIRequirementViewPublicValue.bussinessModel?.baseJsonValue?.rel_serv_rolelist as? [AIServiceProvider]
        
        // expend change UI.
        sourceDelegate.dataSections = arrayAIServiceProvider
        sourceDelegate.hasExecTagModel = childModel?.childServerIconArray
        
        if let arrayAIServiceProvider = arrayAIServiceProvider{
            configureExpend(arrayAIServiceProvider.count)
        }else{
            configureExpend(0)
        }
    }
    
    
    func calcelAction(anyobj: AnyObject) {
        dismissPopupViewController(true, completion: { () -> Void in
        })
    }
    
    func distriAction(anyobj: AnyObject) {
        
        var ridArray = Array<String>()
        var array = Array<AIIconTagModel>()
        for obj in sourceDelegate.selectedDataSections {
            //AIServiceProvider
            var tabModel = AIIconTagModel()
            tabModel.id = obj.relservice_instance_id.integerValue ?? 0
            tabModel.iconUrl = "\(obj.provider_portrait_url)"
            array.append(tabModel)            

            ridArray.append("\(obj.relservice_instance_id.integerValue)")
            
        }
        
        //let bussinessModel = AIRequirementViewPublicValue.bussinessModel
        
        self.view.showLoading()

        let handler = AIRequirementHandler.defaultHandler()
        
        handler.distributeRequirementRequset(childModel?.wish_result_id ?? "",
            wish_item_type: self.contentModel?.category ?? "",
            wish_item_id: childModel?.requirement_id ?? "",
            service_inst_id: ridArray, success: { () -> Void in
            self.view.hideLoading()
            self.delegate?.refereshCell(self.preCell!, contentModel: array)
            self.dismissPopupViewController(true, completion: { () -> Void in
            })

            }) { (errType, errDes) -> Void in
                self.view.hideLoading()
                AIAlertView().showError("error", subTitle: "网络请求失败")
        }

       
    }
    
    func configureExpendCell(cell: AIRACContentCell, atIndexPath indexPath: NSIndexPath, contentModel: AIChildContentCellModel) {
        
        
        // MARK: -> Internal enum
        
        enum ThisViewTag: Int {
            case IconView = 12
            case ExpendView = 13
            case StableView = 14
        }
        
        let vheight = cell.contentView.viewWithTag(ThisViewTag.IconView.rawValue)
        
        vheight?.snp_updateConstraints(closure: { (make) -> Void in
            if cell.hasExpend == true {
                make.height.equalTo(50 + 70 + stableCellHeight * (contentModel.childServerIconArray?.count ?? 0))
            } else {
                make.height.equalTo(50)
            }
        })
        
        let holdView = cell.contentView.viewWithTag(ThisViewTag.ExpendView.rawValue)
        
        holdView?.snp_updateConstraints(closure: { (make) -> Void in
            if cell.hasExpend == true {
                make.height.equalTo(70 + stableCellHeight * (contentModel.childServerIconArray?.count ?? 0))
            } else {
                make.height.equalTo(0)
            }
        })
        
        let stable = holdView?.viewWithTag(ThisViewTag.StableView.rawValue) as? UITableView
        stable?.scrollEnabled = false
        
        stable?.snp_updateConstraints(closure: { (make) -> Void in
            if cell.hasExpend == true {
                make.height.equalTo(holdView!.snp_height)
            } else {
                make.height.equalTo(0)
            }
        })
        
        sourceDelegate.selectedDataSections.removeAll()
        let arrayAIServiceProvider = AIRequirementViewPublicValue.bussinessModel?.baseJsonValue?.rel_serv_rolelist as? [AIServiceProvider]
        sourceDelegate.dataSections = arrayAIServiceProvider
        sourceDelegate.hasExecTagModel = childModel?.childServerIconArray
        
        stable?.reloadData()
        
        _ = holdView?.subviews.filter({ (sview) -> Bool in
            if cell.hasExpend == true {
                sview.hidden = false
            } else {
                sview.hidden = true
            }
            return false
        })
        
    }
}