//
//  AIRequireContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SnapKit
import Spring
import Cartography

class AIWrapperAIContentModelClass{
    
    var cellmodel: AIContentCellModel
    
    init(theModel: AIContentCellModel){
        cellmodel = theModel
    }
    
}



class AIRequireContentViewController: UIViewController {
    
	// MARK: -> Internal enum
	
	enum ThisViewTag: Int {
		case IconView = 12
		case ExpendView = 13
		case StableView = 14
	}
    
    var orderPreModel : AIOrderPreModel?
    
	private let stableCellHeight: Int = 40
	
	@IBOutlet weak var tableview: UITableView!
	
	private var placeholdCell: SESlideTableViewCell?
	
	private var rememberCellButton: AnyObject?
	
    var dataSource: [AIContentCellModel]?
    
    /*= {
		
		var i1 = AIIconTagModel()
		i1.iconUrl = "http://171.221.254.231:3000/upload/proposal/3e7Sx8n4vozQj.png"
		i1.content = "Maternity Consulting "
		
		var i2 = AIIconTagModel()
		i2.iconUrl = "http://171.221.254.231:3000/upload/proposal/LATsJIV2vKdgp.png"
		i2.content = "Paramedk Cleaner"
		
		var i3 = AIIconTagModel()
		i3.iconUrl = "http://171.221.254.231:3000/upload/proposal/EZwliZwHINGpm.png"
		i3.content = "hospital Appointment Booking"
		
		var conModel = AIContentCellModel()
		conModel.id = 12
		conModel.type = 1
		conModel.typeImageUrl = "user-note--0"
		conModel.typeName = "user note"
		
		var c1 = AIChildContentCellModel()
		c1.id = 1
		c1.type = 2
		c1.bgImageUrl = ""
		c1.text = "9 weeks of pregnancy, action inconvenience."
		c1.childServerIconArray = [i1]
		
		var c2 = AIChildContentCellModel()
		c2.id = 2
		c2.type = 2
		c2.bgImageUrl = ""
		c2.text = "Accompany and attend to Accompany and attend"
		c2.childServerIconArray = [i1, i2, i3]
		
		conModel.childServices = [c1, c2]
		
		var msgModel = AIContentCellModel()
		msgModel.id = 13
		msgModel.type = 2
		msgModel.typeImageUrl = "user-message-0"
		msgModel.typeName = "user message"
		
		var c3 = AIChildContentCellModel()
		c3.id = 3
		c3.type = 1
		c3.bgImageUrl = ""
		c3.text = "Body is weak,can not cary heavy , pay attention to nuturetion collocation"
		c3.childServerIconArray = [i1, i3]
		
		var c6 = AIChildContentCellModel()
		c6.id = 6
		c6.type = 1
		c6.bgImageUrl = ""
		c6.text = ""
		c6.audioLengh = 4000
		c6.audioUrl = "http://adskfhasjdhkflhjashflkahsldf"
		
		c6.childServerIconArray = [i3]
		
		msgModel.childServices = [c3, c6]
		
		var dataModel = AIContentCellModel()
		dataModel.id = 14
		dataModel.type = 3
		dataModel.typeImageUrl = "user-data-0"
		dataModel.typeName = "user data"
		
		var c4 = AIChildContentCellModel()
		c4.id = 4
		c4.type = 4
		c4.bgImageUrl = ""
		c4.text = "Fasting blood glucos : 6MM mol /ml."
		c4.content = "Anysls sadFasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml."
		c4.childServerIconArray = [i1, i2, i3]
		
		var c5 = AIChildContentCellModel()
		c5.id = 5
		c5.type = 3
		c5.bgImageUrl = ""
		c5.text = "Fasting blood glucos : 6MM mol /ml."
		c5.content = "Anysls sadFasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml.Fasting blood glucos : 6MM mol /ml."
		c5.childServerIconArray = [i3]
		
		dataModel.childServices = [c5, c4]
		
		return [conModel, msgModel, dataModel]
	}()
	*/
	var editModel: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		tableview.rowHeight = UITableViewAutomaticDimension
		tableview.estimatedRowHeight = 44.0
		tableview.showsVerticalScrollIndicator = false
        tableview.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)

        tableview.addHeaderWithCallback { () -> Void in
            Async.main(after: 1.5, block: { () -> Void in
                self.tableview.reloadData()
                self.tableview.headerEndRefreshing()
            })
        }
        
        // requets data:
        
        if editModel == false {
            requestData()
        }else{
            Async.main { () -> Void in
                self.tableview.reloadData()
                
            }
        }       
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if editModel == true {
            self.tableview.reloadData()
        }
        
    }
    
    func requestData(){
        let handler = AIRequirementHandler.defaultHandler()
        handler.queryUnassignedRequirements((orderPreModel?.proposal_id)!, roleType: 1, success: { [weak self](requirements) -> Void in
            print("\(requirements)")
            
            self!.dataSource  = requirements
            
            // Reloading for the visible cells to layout correctly
            Async.main { () -> Void in
                self!.tableview.reloadData()
            }
            
            }) { (errType, errDes) -> Void in
                print("\(errDes)")
        }
    }
    
}

extension AIRequireContentViewController: UITableViewDelegate, UITableViewDataSource {
	
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
			// 第一行就是标题cell处理
			let cell = tableView.dequeueReusableCellWithIdentifier("cellTitleIDentity")
			let signImgView = cell?.contentView.viewWithTag(3) as! UIImageView
			let signTextView = cell?.contentView.viewWithTag(2) as! UILabel
			signImgView.setImageWithURL(NSURL(string: currentCellModel?.typeImageUrl ?? "")!)
			signTextView.text = currentCellModel?.typeName ?? ""
			signTextView.textColor = UIColor(hexString: "ffffff", alpha: 0.75)
			signTextView.font = AITools.myriadLightSemiCondensedWithSize(13)
			
			return cell!
		} else {
			// Content Cell  Info.
			let contentModel: AIChildContentCellModel = (currentCellModel?.childServices?[indexPath.row - 1])!
			// Cache Cell...
			let CELL_ID = "Cell_\(currentCellModel?.id ?? 0 )_\(contentModel.id ?? 0)"
			
			var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) as? AIRACContentCell
			if cell == nil {
				cell = AIRACContentCell(style: .Default, reuseIdentifier: CELL_ID)
				cell!.selectionStyle = .None
				cell!.delegate = self
				cell!.aiDelegate = self
				cell!.backgroundColor = UIColor.clearColor()
				if let cell = cell {
					configureCell(cell, atIndexPath: indexPath, contentModel: contentModel)
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
	
	func configureCell(cell: AIRACContentCell, atIndexPath indexPath: NSIndexPath, contentModel: AIChildContentCellModel) {
		
		var imageName = "ai_rac_bg_normal"
		switch contentModel.type ?? 0 {
		case 1:
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
		
		// Setup 1 : bg UIIamgeView.
		let bgImageView = UIImageView(image: UIImage(named: imageName)?.stretchableImageWithLeftCapWidth(0, topCapHeight: 10))
		cell.contentView.addSubview(bgImageView)
		
		bgImageView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.leading.trailing.equalTo(0)
			make.bottom.equalTo(-3)
		})
		bgImageView.tag = 11
		bgImageView.alpha = 0
		
		// PlaceHolder UIImageView.
		let bgImageViewHolder = UIImageView(image: UIImage(named: imageName)?.stretchableImageWithLeftCapWidth(0, topCapHeight: 10))
		cell.contentView.addSubview(bgImageViewHolder)
		bgImageViewHolder.tag = 18
        
		// list ImageViews. Support the NSAttributedString.
        var leftOffset = 0
        let urlArray = contentModel.requirement_icon?.componentsSeparatedByString(",")
        if let urlArray = urlArray {
            //Has image url.
            var offsetHeight = 10
            for url in urlArray {
                let urlImage = AIImageView()
                urlImage.setURL(NSURL(string: "\(url)"), placeholderImage: UIImage(named: "Placehold"))
                urlImage.tag = 11
                cell.contentView.addSubview(urlImage)
                
                urlImage.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(offsetHeight)
                    make.leading.equalTo(14)
                    make.width.height.equalTo(13)
                })
                
                offsetHeight += 15
            }
            
            if urlArray.first?.length > 5 {
                leftOffset = 15
            }else{
                leftOffset = 0
            }
            
            
        }else{
            leftOffset = 0
        }
        
        // Setup 2 : Title UILabel.
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        titleLabel.text = contentModel.text ?? ""
        titleLabel.font = AITools.myriadLightSemiCondensedWithSize(15)
        titleLabel.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(10)
            make.leading.equalTo(14+leftOffset)
            make.trailing.equalTo(-14)
            make.height.greaterThanOrEqualTo(20).priorityMedium()
        })
        titleLabel.tag = 11
        
		
		// Setup 2.1 : Audio View.
		let lengthAudio = contentModel.audioLengh ?? 0
		
		let audioModel = AIProposalServiceDetailHopeModel()
		audioModel.audio_url = contentModel.audioUrl ?? ""
		audioModel.time = lengthAudio
		let audio1 = AIAudioMessageView.currentView()
//        audio1.audioDelegate = self
		cell.contentView.addSubview(audio1)
		audio1.tag = 11
		audio1.fillData(audioModel)
		audio1.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(2)
			make.leading.equalTo(2)
			make.trailing.equalTo(-14)
			make.height.equalTo(30)
		}
		
		if lengthAudio > 0 {
			audio1.alpha = 1
			titleLabel.text = ""
		} else {
			audio1.alpha = 0
		}
		
		// Setup 3: Description UILabel.
		let desLabel = UILabel()
		desLabel.numberOfLines = 0
		desLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
		desLabel.text = contentModel.content ?? ""
		desLabel.font = AITools.myriadLightSemiCondensedWithSize(15)
		desLabel.textColor = UIColor.whiteColor()
		cell.contentView.addSubview(desLabel)
		
		desLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(5)
			make.leading.equalTo(14)
			make.trailing.equalTo(-14)
			make.height.lessThanOrEqualTo(20)
		})
		desLabel.tag = 11
		
		// Setup 4: Line UIImageView.
		let lineImageView = UIImageView(image: UIImage(named: "orderline"))
		cell.contentView.addSubview(lineImageView)
		var margeLeftOffset: CGFloat = 0
		if (contentModel.type ?? 0) == 1 {
			margeLeftOffset = 6
		}
		if contentModel.type >= 3 {
			lineImageView.alpha = 0
		} else {
			lineImageView.alpha = 1
		}
		
		lineImageView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(desLabel.snp_bottom).offset(5)
			make.leading.trailing.equalTo(margeLeftOffset)
			make.height.equalTo(1)
		})
		
		lineImageView.tag = 11
		
		// Setup 5: Icon Arrays.
		
		let iconView = UIView()
		cell.contentView.addSubview(iconView)
		
		refereshIconData(iconView, contentModel: contentModel.childServerIconArray, cell: cell)
		
		iconView.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(lineImageView.snp_bottom).offset(5)
			make.leading.equalTo(14)
			make.trailing.equalTo(-14)
			make.height.equalTo(50).priorityMedium()
			make.bottom.equalTo(cell.contentView).offset(20)
		})
		iconView.tag = ThisViewTag.IconView.rawValue
		
		bgImageViewHolder.snp_makeConstraints(closure: { (make) -> Void in
			make.top.leading.trailing.equalTo(0)
			make.bottom.equalTo(iconView.snp_top).offset(25)
		})
		
		// Setup 6:  expendTableViewCell
		
		cell.addRightButtonWithImage(UIImage(named: "racright"), backgroundColor: UIColor(hexString: "#0B1051"))
		cell.addLeftButtonWithImage(UIImage(named: "AIROAddTag"), backgroundColor: UIColor(hexString: "#0D0F51"))
		cell.addLeftButtonWithImage(UIImage(named: "AIROAddNote"), backgroundColor: UIColor(hexString: "#1C2071"))
		cell.addLeftButtonWithImage(UIImage(named: "AIROAddTask"), backgroundColor: UIColor(hexString: "#1E2089"))
		
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
	}
	
	
	// TODO: Do something with refersh icon view's subviews data.
	func refereshIconData(iconView: UIView, contentModel: [AIIconTagModel]?, cell: AIRACContentCell) {
		
		var index: Int = 0
		if let models = contentModel {
			
			for model in models {
				let imageV = AIImageView()
				imageV.setURL(NSURL(string: model.iconUrl ?? ""), placeholderImage: UIImage(named: "PlaceHolder"))
				iconView.addSubview(imageV)
				
				imageV.snp_makeConstraints(closure: { (make) -> Void in
					make.top.equalTo(iconView).offset(0)
					make.left.equalTo(iconView).offset(index * 25)
					make.width.height.equalTo(20)
				})
				index = index + 1
			}
		}
		
		if editModel == true {
			let editButton = UIButton(type: UIButtonType.Custom)
			editButton.setImage(UIImage(named: "dt_add"), forState: UIControlState.Normal)
			iconView.addSubview(editButton)
			editButton.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(iconView).offset(0)
				make.left.equalTo(iconView).offset(index * 25)
				make.width.height.equalTo(20)
			})
			editButton.addTarget(cell, action: "AddExpendCell:", forControlEvents: UIControlEvents.TouchUpInside)
		}
	}
	
}

// MARK: - Cell Call back Event.

extension AIRequireContentViewController: ExpendTableViewCellDelegate,AISelectedServiceTableVControllerDelegate {
    
    func refereshCell(cell: AIRACContentCell, contentModel: [AIIconTagModel]?) {
        let iconView = cell.contentView.viewWithTag(ThisViewTag.IconView.rawValue)
        
        _ = iconView?.subviews.filter({ (sview) -> Bool in
            SpringAnimation.springWithCompletion(0.3, animations: { () -> Void in
                sview.alpha = 0
                }, completion: { (complate) -> Void in
                    sview.removeFromSuperview()
            })
            return false
        })
        
        if let iconView = iconView {
             refereshIconData(iconView, contentModel: contentModel, cell: cell)
        } 
    }
	
	func expendTableViewCell(cell: AIRACContentCell, expendButtonPressed sender: AnyObject) {
        
        let indexPath = tableview.indexPathForCell(cell)!
        let currentCellModel = dataSource?[indexPath.section]
        let contentModel: AIChildContentCellModel = (currentCellModel?.childServices?[indexPath.row - 1])!
        let vc = AISelectedServiceTableVController()
        vc.childModel = contentModel
        vc.preCell = cell
        vc.delegate = self
        presentPopupViewController(vc, animated: true)
	}
	
	// reload
	func expendTableViewCellSizeDidChange(cell: AIRACContentCell) {
		if let _ = tableview.indexPathForCell(cell) {
			self.tableview.reloadData()
		}
	}
}

extension AIRequireContentViewController: SESlideTableViewCellDelegate {
	
	func slideTableViewCell(cell: SESlideTableViewCell!, canSlideToState slideState: SESlideTableViewCellSlideState) -> Bool {
		return !editModel
	}
	
	func slideTableViewCell(cell: SESlideTableViewCell!, didSlideToState slideState: SESlideTableViewCellSlideState) {
		if slideState != SESlideTableViewCellSlideState.Center {
			self.tableview.scrollEnabled = false
			placeholdCell = cell
		} else {
			self.tableview.scrollEnabled = true
			placeholdCell = nil
		}
	}
	
	func slideTableViewCell(cell: SESlideTableViewCell!, didTriggerLeftButton buttonIndex: Int) {
		
		cell.setSlideState(.Center, animated: true)
		switch buttonIndex {
		case 0:
			// 转化标签
			print(buttonIndex)
			addTagButtonPressed()
			
		case 1:
			// 转化备注
			print(buttonIndex)
			addNoteButtonPressed()
			
		case 2:
			// 转化任务节点
			print(buttonIndex)
			addTaskButtonPressed()
			
		default:
			break
		}
	}
	
	func slideTableViewCell(cell: SESlideTableViewCell!, didTriggerRightButton buttonIndex: Int) {
        let imageView = cell.contentView.viewWithTag(18) as! UIImageView
        let img = UIImage(named: "racselectedbg")?.stretchableImageWithLeftCapWidth(0, topCapHeight: 10)
        imageView.image = img
        cell.setSlideState(.Center, animated: true)
        cell.setNeedsDisplay()
        let indexPath = tableview.indexPathForCell(cell)!
        let currentCellModel = dataSource?[indexPath.section]
        let contentModel: AIChildContentCellModel = (currentCellModel?.childServices?[indexPath.row - 1])!
        
        var cellModel: AIContentCellModel = currentCellModel!
        cellModel.childServices = nil
        cellModel.childServices = [contentModel]
        
        
        let obj = AIWrapperAIContentModelClass(theModel: cellModel)
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementNotifyOperateCellNotificationName, object: nil,userInfo: ["data":obj])
        
	}
	
	func slideTableViewCell(cell: SESlideTableViewCell!, willSlideToState slideState: SESlideTableViewCellSlideState) {
	}
	
	func slideTableViewCell(cell: SESlideTableViewCell!, wilShowButtonsOfSide side: SESlideTableViewCellSide) {
		if let preCell = placeholdCell {
			if preCell != cell {
				// 同一个cell
				preCell.setSlideState(SESlideTableViewCellSlideState.Center, animated: true)
			}
		}
	}
}

// MARK: - storyboard
extension AIRequireContentViewController {
	
	@IBAction func addTagButtonPressed() {
       //fake data
        let tagDescs = ["Accompnay and attend to", "About the car", "Nutritional meal", "Fitness regime", "Psychotherapy", "Accompnay and attend to", "About the car"]
//        let tagDescs = ["Dsfadfsaafsdfsda","Dsfadfsaafsdfsda","Fsdasdfafsdasadfsadfdsfa","Safddfsadfsasadfdfsa"]
        var tags = [RequirementTag]()
        for i in 0 ... tagDescs.count - 1 {
            let tag = RequirementTag(id: random()%10000,selected: i % 2 == 0, textContent: tagDescs[i])
           tags.append(tag)
        }
       // end fake
        
        
        let vc = AITaskTagViewController()
        vc.tags = tags

        vc.onDidSelected = {selectedTags, unSelectedTags in
            print("select tag : \(selectedTags)")
        }
        
        vc.onDidCancel = {
            print("select tag cancel")
        }
    
		presentViewController(vc, animated: true, completion: nil)
	}
	
	@IBAction func addNoteButtonPressed() {
		let vc = AITaskNoteEditViewController()
        // pass AIRequirementItem into vc
//        vc.requirementItem = AIRequirementItem
		presentViewController(vc, animated: true, completion: nil)
	}
	@IBAction func addTaskButtonPressed() {
		let vc = AITaskEditViewController()
		presentViewController(vc, animated: true, completion: nil)
	}
}


