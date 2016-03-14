//
//  AITimePickerView.swift
//
//
//  Created by admin on 3/10/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

let secondsInOneMinute: Int = 60
let secondsInOneHour: Int = 60 * secondsInOneMinute
let secondsInOneDay: Int = 24 * secondsInOneHour

class AITimePickerView: UIPickerView {
	
	var date: NSDate?
	
	enum AIPickerComponent: Int {
		case Image, Day, Hour, Minute
	}
	
	struct Constants {
		static var imageComponentWidth: CGFloat = 50
	}
	
	var spots = [UIImage]()
	var days = [String]()
	var hours = [String]()
	var minutes = [String]()
	var data = [Int: [AnyObject]]()
	
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
		backgroundColor = UIColor(red: 0.0392, green: 0.1137, blue: 0.3765, alpha: 1.0)
		delegate = self
		dataSource = self
		let images = ["blue", "orange"]
		for image in images {
			spots.append(UIImage(named: image)!)
		}
		
		for i in 0 ..< 20 {
			var unit = "Days"
			if i <= 0 {
				unit = "Day"
			}
			let label = "\(i) \(unit)"
			days.append(label)
		}
		
		for i in 0 ..< 24 {
			var unit = "Hours"
			if i <= 0 {
				unit = "Hour"
			}
			let label = "\(i) \(unit)"
			hours.append(label)
		}
		
		for i in 0 ..< 60 {
			var unit = "Minutes"
			if i <= 0 {
				unit = "Minute"
			}
			let label = "\(i) \(unit)"
			minutes.append(label)
		}
		data[0] = spots
		data[1] = days
		data[2] = hours
		data[3] = minutes
		
        
        reload()
	}
    
    func reload() {
        if let date = date {
            // if has set date
            let timeIntervalSinceNow = Int(fabs((date.timeIntervalSinceNow)))
            let isFuture = date.timeIntervalSinceNow > 0
            
            let day = timeIntervalSinceNow / secondsInOneDay
            let timeIntervalSinceNowWithoutDay = timeIntervalSinceNow - day * secondsInOneDay
            let hour = timeIntervalSinceNowWithoutDay / secondsInOneHour
            let timeIntervalSinceNowWithoutDayAndHour = timeIntervalSinceNowWithoutDay - hour * secondsInOneHour
            let minute = timeIntervalSinceNowWithoutDayAndHour / secondsInOneMinute
            
            if Int(day) > days.count {
                days.removeAll()
                for i in 0 ..< Int(day) + 1 {
                    var unit = "Days"
                    if i <= 0 {
                        unit = "Day"
                    }
                    let label = "\(i) \(unit)"
                    days.append(label)
                }
                data[1] = days
            }
            
            selectRow(isFuture ? 1 : 0, inComponent: 0, animated: false)
            selectRow(day, inComponent: 1, animated: false)
            selectRow(hour, inComponent: 2, animated: false)
            selectRow(minute, inComponent: 3, animated: false)
        }
    }
	
	func labelWithString(string: String) -> UILabel {
		let result = UILabel()
		result.text = string
		result.textColor = UIColor(red: 0.1216, green: 0.5255, blue: 0.9961, alpha: 1.0)
		result.sizeToFit()
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
		
		let timeIntervalSinceNow = (day * secondsInOneDay + hour * secondsInOneHour + minute * secondsInOneMinute) * (isFuture ? 1 : -1)
		let result = NSDate(timeIntervalSinceNow: Double(timeIntervalSinceNow))
		return result
	}
}

extension AITimePickerView: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 4
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return (data[component]?.count)!
	}
}

extension AITimePickerView: UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
		let c = AIPickerComponent(rawValue: component)!
		
		switch c {
		case .Image:
			
			if let imageView = view as? UIImageView {
				imageView.image = spots[row]
				return imageView
			} else {
				let imageView = UIImageView(image: spots[row])
				imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
				return imageView
			}
			
		case .Day: fallthrough
		case .Hour: fallthrough
		case .Minute:
			let text = data[component]![row] as! String
			if let label = view as? UILabel {
				label.text = text
				return label
			} else {
				let label = labelWithString(text)
				return label
			}
		}
	}
	
	func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		if let component = AIPickerComponent(rawValue: component) {
			switch component {
			case .Image:
				return Constants.imageComponentWidth
			case .Day:
				return (pickerView.frame.width - Constants.imageComponentWidth) / 3 - 10
			case .Hour:
				return (pickerView.frame.width - Constants.imageComponentWidth) / 3
			case .Minute:
				return (pickerView.frame.width - Constants.imageComponentWidth) / 3
			}
		} else {
			return 0 // avoid compiler warning
		}
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		var selectedRows = [Int]()
		for i in 0 ..< 4 {
			selectedRows.append(selectedRowInComponent(i))
		}
		date = convertSelectedRowsToDate(selectedRows)
	}
}