//
//  AITimePickerView.swift
//
//
//  Created by admin on 3/10/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

let second: Int = 1
let secondsInOneMinute: Int = 60 * second
let secondsInOneHour: Int = 60 * secondsInOneMinute
let secondsInOneDay: Int = 24 * secondsInOneHour

class AITimePickerView: UIPickerView {
	
	var date: NSDate?
	
	var taskDate: NSDate?
	
	enum AIPickerComponent: Int {
		case Image, Day, Hour, Minute
	}
	
	struct Constants {
		static let imageComponentWidth: CGFloat = 44 + 23.333333333
		static let cellLabelTag = 131234
		static let cellIconTag = 1123421
		static let hugeNumber = 10000
		static let font = AITools.myriadSemiCondensedWithSize(72 / 3)
		static let textColor = UIColorFromHex(0x219bff)
	}
	
	var days = [String]()
	var hours = [String]()
	var minutes = [String]()
	var data = [Int: [AnyObject]]()
	var dateDescription: String?
	
	lazy var dayUnitLabel: UILabel = {
		let result = UILabel()
		result.text = "days"
		result.font = Constants.font
		result.textColor = Constants.textColor
		result.sizeToFit()
		return result
	}()
	
	lazy var hourUnitLabel: UILabel = {
		let result = UILabel()
		result.text = "hours"
		result.font = Constants.font
		result.textColor = Constants.textColor
		result.sizeToFit()
		return result
	}()
	
	lazy var minuteUnitLabel: UILabel = {
		let result = UILabel()
		result.text = "minutes"
		result.font = Constants.font
		result.textColor = Constants.textColor
		result.sizeToFit()
		return result
	}()
	
	lazy var imageColumnView: CustomPickerColumnView = {
		[unowned self] in
		let result = CustomPickerColumnView()
		result.delegate = self
		self.addSubview(result)
		return result
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		clipsToBounds = false
		backgroundColor = UIColor.clearColor()
		delegate = self
		dataSource = self
		
		for i in 0 ..< 100 {
			let label = "\(i)"
			days.append(label)
		}
		
		for i in 0 ..< 24 {
			let label = String(format: "%.2d", arguments: [i])
			hours.append(label)
		}
		
		for i in 0 ..< 60 {
			let label = String(format: "%.2d", arguments: [i])
			minutes.append(label)
		}
		
		data[1] = days
		data[2] = hours
		data[3] = minutes
		
		reload()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		bringSubviewToFront(imageColumnView)
		let height = CGRectGetHeight(bounds)
		imageColumnView.frame = CGRect(x: 0, y: 0, width: Constants.imageComponentWidth, height: height - 40)
		imageColumnView.setCenterY(height / 2)
		
		var lines = subviews.filter { (v) -> Bool in
			return v.frame.size.height < 2
		}
		
		if lines.count == 2 {
			var topLine: UIView?
			var bottomLine: UIView?
			if lines[0].y > lines[1].y {
				topLine = lines[0]
				bottomLine = lines[1]
			} else {
				topLine = lines[1]
				bottomLine = lines[0]
			}
			
			topLine?.backgroundColor = UIColorFromHex(0xacdaff, alpha: 0.28)
			bottomLine?.backgroundColor = UIColorFromHex(0xacdaff, alpha: 0.28)
			bringSubviewToFront(topLine!)
			bringSubviewToFront(bottomLine!)
			
			addSubview(dayUnitLabel)
			addSubview(hourUnitLabel)
			addSubview(minuteUnitLabel)
			
			let dayValueLabel: UIView! = viewForRow(selectedRowInComponent(1), forComponent: 1)?.viewWithTag(Constants.cellLabelTag)
			let hourValueLabel: UIView! = viewForRow(selectedRowInComponent(2), forComponent: 2)?.viewWithTag(Constants.cellLabelTag)
			let minuteValueLabel: UIView! = viewForRow(selectedRowInComponent(3), forComponent: 3)?.viewWithTag(Constants.cellLabelTag)
			
			let dayValueLabelFrameOnSelf = dayValueLabel.convertRect(dayValueLabel.bounds, toView: self)
			let hourValueLabelFrameOnSelf = hourValueLabel.convertRect(hourValueLabel.bounds, toView: self)
			let minuteValueLabelFrameOnSelf = minuteValueLabel.convertRect(minuteValueLabel.bounds, toView: self)
			
			let space: CGFloat = 4
			dayUnitLabel.setX(CGRectGetMaxX(dayValueLabelFrameOnSelf) + space)
			hourUnitLabel.setX(CGRectGetMaxX(hourValueLabelFrameOnSelf) + space)
			minuteUnitLabel.setX(CGRectGetMaxX(minuteValueLabelFrameOnSelf) + space)
			
			dayUnitLabel.setY(CGRectGetMinY(dayValueLabelFrameOnSelf))
			hourUnitLabel.setY(CGRectGetMinY(dayValueLabelFrameOnSelf))
			minuteUnitLabel.setY(CGRectGetMinY(dayValueLabelFrameOnSelf))
		}
	}
	
	func reload() {
		let multiplier = Constants.hugeNumber / 2
//		let startRowImage = 1
		let startRowDay = 0
		let startRowHour = 24 * multiplier
		let startRowMinute = 60 * multiplier
		if let date = date, taskDate = taskDate {
			// if has set date
			let timeIntervalSinceTaskDateAbs = Int(fabs((date.timeIntervalSinceDate(taskDate))))
			let timeIntervalSinceTaskDate = date.timeIntervalSinceDate(taskDate)

            if timeIntervalSinceTaskDate > 0 {
                imageColumnView.row = 2
            } else if timeIntervalSinceTaskDate == 0 {
                imageColumnView.row = 1
            } else {
                imageColumnView.row = 0
            }

			let day = timeIntervalSinceTaskDateAbs / secondsInOneDay
			let timeIntervalSinceTaskDateWithoutDay = timeIntervalSinceTaskDateAbs - day * secondsInOneDay
			let hour = timeIntervalSinceTaskDateWithoutDay / secondsInOneHour
			let timeIntervalSinceTaskDateWithoutDayAndHour = timeIntervalSinceTaskDateWithoutDay - hour * secondsInOneHour
			let minute = timeIntervalSinceTaskDateWithoutDayAndHour / secondsInOneMinute
			
			if Int(day) > days.count {
				days.removeAll()
				for i in 0 ..< Int(day) + 1 {
					let label = "\(i)"
					days.append(label)
				}
				data[1] = days
			}
			
			selectRow(day, inComponent: 1, animated: false)
			selectRow(hour + startRowHour, inComponent: 2, animated: false)
			selectRow(minute + startRowMinute, inComponent: 3, animated: false)
		} else {
			selectRow(startRowDay, inComponent: 1, animated: false)
			selectRow(startRowHour, inComponent: 2, animated: false)
			selectRow(startRowMinute, inComponent: 3, animated: false)
		}
	}
	
	func labelWithString(string: String, labelX: CGFloat) -> UIView {
		let label = UILabel()
		label.textAlignment = .Left
		label.font = Constants.font
		label.textColor = Constants.textColor
		
		label.text = "00"
		label.sizeToFit()
		label.text = string
		label.setX(labelX)
		label.tag = Constants.cellLabelTag
		
		let result = UIView()
		result.bounds = label.bounds
		result.setWidth((CGRectGetWidth(bounds) - Constants.imageComponentWidth) / 3)
		result.addSubview(label)
		
		return result
	}
	
	func convertDateToSelectedRows(date: NSDate) -> [Int] {
		let timeIntervalSinceNow = Int(fabs((date.timeIntervalSinceNow)))
		let isFuture = date.timeIntervalSinceNow > 0
		
		let day = timeIntervalSinceNow / secondsInOneDay
		let timeIntervalSinceNowWithoutDay = timeIntervalSinceNow - day * secondsInOneDay
		let hour = timeIntervalSinceNowWithoutDay / secondsInOneHour
		let timeIntervalSinceNowWithoutDayAndHour = timeIntervalSinceNowWithoutDay - hour * secondsInOneHour
		let minute = timeIntervalSinceNowWithoutDayAndHour / secondsInOneMinute
		
		var result = [Int]()
		result.append(isFuture ? 1 : 0)
		result.append(day)
		result.append(hour)
		result.append(minute)
		return result
	}
	
	func convertSelectedRowsToDate(selectedRows: [Int]) -> NSDate {
		let isFuture = selectedRows[0] == 1
		let day = selectedRows[1]
		let hour = selectedRows[2]
		let minute = selectedRows[3]
		
		let timeIntervalSinceTaskDate = (day * secondsInOneDay + hour * secondsInOneHour + minute * secondsInOneMinute) * (isFuture ? 1 : -1)
		let result = NSDate(timeInterval: Double(timeIntervalSinceTaskDate), sinceDate: taskDate!)
		return result
	}
	
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		if CGRectContainsPoint(imageColumnView.frame, point) {
			return imageColumnView.hitTest(point, withEvent: event)
		} else {
			return super.hitTest(point, withEvent: event)
		}
	}
}

extension AITimePickerView: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 4
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		let c = AIPickerComponent(rawValue: component)!
		switch c {
		case .Image:
			return 0
		case .Day:
			return (data[1]?.count)!
		case .Hour: fallthrough
		case .Minute:
			return (data[component]?.count)! * Constants.hugeNumber
		}
	}
}

extension AITimePickerView: UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
		let c = AIPickerComponent(rawValue: component)!
		
		switch c {
		case .Image:
			return UIView() // avoid compiler warning
			
		case .Day: fallthrough
		case .Hour: fallthrough
		case .Minute:
			let text = (data[component]![row % (data[component]?.count)!]) as! String
			if let label = view?.viewWithTag(Constants.cellLabelTag) as? UILabel {
				label.text = text
				return view!
			} else {
				let labelXs: [CGFloat] = [70 / 3, 30 / 3, 30 / 3]
				let containerView = labelWithString(text, labelX: labelXs[component - 1])
				return containerView
			}
		}
	}
	
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 160 / 3
	}
	
	func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		let pickerComponent = AIPickerComponent(rawValue: component)!
		let magicNumber: CGFloat = 20
		switch pickerComponent {
		case .Image:
			return Constants.imageComponentWidth
		case .Day: fallthrough
		case .Hour:
			return (pickerView.frame.width - Constants.imageComponentWidth) / 3 - magicNumber
		case .Minute:
			return (pickerView.frame.width - Constants.imageComponentWidth) / 3
		}
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		var selectedRows = [Int]()
        // before 0 , now 1 after 2
		let isBefore = component == 0 ? row : imageColumnView.row
		
		for i in 0 ..< 4 {
			if i != 0 {
				if isBefore == 1 {
					selectedRows.append(0)
				} else {
					let selectedRow = selectedRowInComponent(i) % (data[i]?.count)!
					selectedRows.append(selectedRow)
				}
			} else {
				selectedRows.append(imageColumnView.row)
			}
		}
		let isBeforeStrings = ["Before ", "", "After "]
		let isBeforeString = isBeforeStrings[isBefore]
		
		let days = "\(selectedRows[1]) days"
		let hours = "\(selectedRows[2]) hours"
		let minutes = "\(selectedRows[3]) minutes"
		
		dateDescription = isBeforeString + "" + days + " " + hours + " " + minutes
		date = convertSelectedRowsToDate(selectedRows)
	}
	
	override func selectedRowInComponent(component: Int) -> Int {
		if component > 0 {
			return super.selectedRowInComponent(component)
		} else {
			return imageColumnView.row
		}
	}
}

extension AITimePickerView: CustomPickerColumnViewDelegate {
	func customPickerView(customPickerView: CustomPickerColumnView, didSelectRow row: Int) {
		pickerView(self, didSelectRow: row, inComponent: 0)
	}
}