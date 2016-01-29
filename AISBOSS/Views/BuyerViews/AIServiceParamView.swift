//
//  AIServiceParamView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

@objc protocol AIServiceParamViewDelegate : class {
	func serviceParamsViewHeightChanged(offset : CGFloat, view : UIView)
}

class AIServiceParamView : UIView {
	
	// MARK: Constants
	let margin : CGFloat = 10
	
	let originalX : CGFloat = 10
	
	var sviewWidth : CGFloat
	// MARK: Variables
	
	weak var delegate : AIServiceParamViewDelegate?
    var onDropdownBrandViewSelectedIndexDidChanged: ((AIDropdownBrandView, Int) -> ())? = nil
	var tagViewHeight : CGFloat?
	
	var brandsViewHeight : CGFloat?
	
	var displayViews = [UIView]()
	
	var displayModels : NSArray?
	
	weak var rootViewController : UIViewController?
	var originalY : CGFloat = 0
	
	// MARK: Override
	
	init(frame : CGRect, models: NSArray?, rootViewController: UIViewController) {
		sviewWidth = CGRectGetWidth(frame) - originalX * 2
		super.init(frame: frame)
		
		if let _ = models {
			self.rootViewController = rootViewController
			displayModels = models
			parseModels(displayModels!)
			resetFrameHeight(originalY)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Method
	
	// MARK: 解析数据模型
	func parseModels(models : NSArray) {
		
		for var i = 0; i < models.count; i++ {
			
			let model : JSONModel = models.objectAtIndex(i) as! JSONModel
			let type : Int = model.displayType as Int
			switch (type) {
			case 1: // title + detail
				addView1(model)
				break;
			case 2: // 单选checkbox组
				addView2(model)
				break;
			case 3: // 金额展示
				addView3(model)
				break;
			case 4: // 标签组复合控件，可多选，单选，可分层
				addView4(model)
				break;
			case 5: // 时间，日历
				addView5(model)
				break;
			case 6: // 输入框
				addView6(model)
				break;
			case 7: // 普通标签：title + 标签组
				addView7(model)
				break;
			case 8: // 切换服务标签
				addView8(model)
				
			case 9: // picker控件
				addView9(model)
				break;
			default:
				break;
			}
		}
	}
	
	// MARK: Reset Frame
	func resetFrameHeight(height : CGFloat) {
		var frame = self.frame
		frame.size.height = height
		self.frame = frame
	}
	
	// MARK: Display 1
	
	func addView1(model : JSONModel) {
		let m : AIDetailTextModel = model as! AIDetailTextModel
		let frame = CGRectMake(originalX, originalY, sviewWidth, 0)
		let detailText = AIDetailText(frame: frame, titile: m.title, detail: m.content)
		addSubview(detailText)
		
		originalY += CGRectGetHeight(detailText.frame) + margin
		
		displayViews.append(detailText)
	}
	
	// MARK: Display 2
	func addView2(model : JSONModel) {
		let m = model as! AIServiceTypesModel
		let frame = CGRectMake(originalX, originalY, sviewWidth, 0)
		let types : AIServiceTypes = AIServiceTypes(frame: frame, model: m)
		addSubview(types)
		
		originalY += CGRectGetHeight(types.frame) + margin
		displayViews.append(types)
	}
	
	// MARK: Display 3
	func addView3(model : JSONModel) {
		let m : AIPriceViewModel = model as! AIPriceViewModel
		let frame = CGRectMake(0, originalY, sviewWidth + margin * 2, 100)
		let priceView : AIPriceView = AIPriceView(frame: frame, model: m)
		addSubview(priceView)
		
		originalY += CGRectGetHeight(priceView.frame) + margin
		displayViews.append(priceView)
	}
	
	// MARK: Display 4
	func addView4(model : JSONModel) {
		let m : AIComplexLabelsModel = model as! AIComplexLabelsModel
		let frame = CGRectMake(0, originalY, sviewWidth, 0)
		
		let tagsView : AITagsView = AITagsView(title: m.title, tags: m.labels as! [Tagable], frame: frame)
		addSubview(tagsView)
		tagsView.originalModel = m
		tagsView.addTarget(self, action: "handleTagsViewChanged:", forControlEvents: .ValueChanged)
		tagViewHeight = CGRectGetHeight(tagsView.frame)
		originalY += tagViewHeight! + margin
		
		displayViews.append(tagsView)
	}
	
	func handleTagsViewChanged(sender: AITagsView) {
		let offset : CGFloat = sender.frame.size.height - tagViewHeight!
		tagViewHeight = sender.frame.size.height
		// TODO: 下移所有在之下的view
		if offset != 0 {
			moveViewsBelow(sender, offset: offset)
			if let _ = self.delegate {
				self.delegate?.serviceParamsViewHeightChanged(offset, view: self)
			}
		}
	}
	
	// MARK: Display 5
	func addView5(model : JSONModel) {
		
		 let m : AICanlendarViewModel = model as! AICanlendarViewModel
		let frame = CGRectMake(originalX, originalY, sviewWidth, 0)
		
		let pickerView = AIEventTimerView.currentView()
		addSubview(pickerView)
		pickerView.title.text = m.title ?? ""
		pickerView.timeContent.setTitle(m.calendar ?? "", forState: .Normal)
		pickerView.setY(originalY)
		pickerView.newFrame = frame
        pickerView.displayModel = m
		originalY += CGRectGetHeight(pickerView.frame) + margin
		displayViews.append(pickerView)
	}
	
	// MARK: Display 6
	func addView6(model : JSONModel) {
		let m : AIInputViewModel = model as! AIInputViewModel
		let frame = CGRectMake(originalX, originalY, sviewWidth, 0)
		
		let inputView : AIInputView = AIInputView(frame: frame, model: m)
		inputView.root = rootViewController
		addSubview(inputView)
		
		originalY += CGRectGetHeight(inputView.frame) + margin
		displayViews.append(inputView)
	}
	
	// MARK: Display 7
	func addView7(model : JSONModel) {
		let m : AIServiceCoverageModel = model as! AIServiceCoverageModel
		let frame = CGRectMake(originalX, originalY, sviewWidth, 0)
		
		let coverage : AIServiceCoverage = AIServiceCoverage(frame: frame, model: m)
		addSubview(coverage)
		
        originalY += CGRectGetHeight(coverage.frame) > 0 ? CGRectGetHeight(coverage.frame) + margin : CGRectGetHeight(coverage.frame)
		displayViews.append(coverage)
	}
	
	// MARK: Display 8
	func addView8(model : JSONModel) {
		let m : AIServiceProviderViewModel = model as! AIServiceProviderViewModel
		let frame = CGRectMake(0, originalY, sviewWidth + margin * 2, 0)
		
		var brands : [(title: String, image: String)] = []
		var index : Int = 0
		for var i : Int = 0; i < m.providers.count; i++ {
			let provider : AIServiceProviderModel = m.providers[i] as! AIServiceProviderModel
            if let name = provider.name {
                brands.append((title: name, image: provider.icon))
//			brands.append((title: "\(provider.name)", image: "\(provider.icon)"))
                if provider.isSelected {
                    index = i
                }
            }
			if provider.isSelected {
				index = i
			}
		}
		
		let serviceProviderView : AIDropdownBrandView = AIDropdownBrandView(brands: brands, selectedIndex: index, frame: frame)
		addSubview(serviceProviderView)
        serviceProviderView.displayModel = m
		
		serviceProviderView.onDownButtonDidClick = { [weak self] bView in
			let frameBefore = bView.frame
			bView.isExpanded = !bView.isExpanded
			let frameAfter = bView.frame
			let offset = CGRectGetMaxY(frameAfter) - CGRectGetMaxY(frameBefore)
			self?.moveViewsBelow(serviceProviderView, offset: offset)
		}
		
		serviceProviderView.onSelectedIndexDidChanged = {[weak self] bView, selectedIndex in
			// handle selected index changed
            if let c = self?.onDropdownBrandViewSelectedIndexDidChanged {
                c(bView,selectedIndex)
            }
		}
		
		originalY += CGRectGetHeight(serviceProviderView.frame) + margin
		displayViews.append(serviceProviderView)
	}
	
	// MARK: Display 9
	func addView9(model : JSONModel) {
		// let m : AIPickerViewModel = model as! AIPickerViewModel
		originalY += 20
		let frame = CGRectMake(originalX, originalY, sviewWidth, 0)
		let singleSelectView = AISingleSelectView(frame: frame)
		addSubview(singleSelectView)
		originalY += CGRectGetHeight(singleSelectView.frame) + margin
		displayViews.append(singleSelectView)
	}
	
	// MARK: 移动视图
	
	func moveViewsBelow(view : UIView, offset : CGFloat) {
		
		// find anchor
		let anchor = displayViews.indexOf(view)! + 1
        
		// move
		
		for var index : Int = anchor; index < displayViews.count; index++ {
			let sview : UIView = displayViews[index]
			var frame = sview.frame
            frame.origin.y += offset
			UIView.animateWithDuration(0.25, animations: { () -> Void in
				sview.frame = frame
			})
		}
		
		var f = frame
        let frameBefore = f
		f.size.height = CGRectGetMaxY(displayViews.last!.frame)
		frame = f
        let frameAfter = f
        let newOffset = CGRectGetMaxY(frameAfter) - CGRectGetMaxY(frameBefore)
		
		// post relayout view notification
//    kServiceParamsViewHeightChanged
        let obj = ["view":self,"offset":newOffset]
        NSNotificationCenter.defaultCenter().postNotificationName("kServiceParamsViewHeightChanged", object: obj)
	}
    
    
    
    //MARK: 获取参数
    
    func getAllParams() -> [String : AnyObject]? {
        var saveData : [String : AnyObject] = [String : AnyObject]()
        let productList : NSMutableArray = NSMutableArray()
        let serviceList : NSMutableArray = NSMutableArray()
        let priceList : NSMutableArray = NSMutableArray()
        
        displayViews.forEach { (view) -> () in
            
            let paramView : AIServiceParamBaseView = view as! AIServiceParamBaseView
            if paramView is AIPriceView {
                if let list = paramView.serviceParamsList() {
                    if list.count > 0 {
                        priceList.addObjectsFromArray(list)
                    }
                }
            }
            else {
                if let list = paramView.productParamsList() {
                    if list.count > 0 {
                        productList.addObjectsFromArray(list)
                    }
                }
                
                if let list = paramView.serviceParamsList() {
                    if list.count > 0 {
                        serviceList.addObjectsFromArray(list)
                    }
                }
            }
 
        }
        
        if productList.count > 0 {
            saveData["product_list"] = productList
        }
        
        if serviceList.count > 0 {
            saveData["service_param_list"] = serviceList
        }
        
        if priceList.count > 0 {
            saveData["price_param_list"] = priceList
        }
        
        if saveData.keys.count > 0 {
            return saveData
        }
        
        return nil
  
    }
}

extension AIComplexLabelModel : Tagable {
	var id : Int {
		get {
			return identifier
		}
	}
	
	var subtags: [Tagable]? {
		get { return sublabels as? [Tagable] }
	}
	
	var selected: Bool {
		get { return isSelected }
	}
	
	var title: String {
		get { return self.atitle }
	}
	
	var desc: String? {
		get { return self.adesc }
	}
}

