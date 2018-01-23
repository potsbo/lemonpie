//
//  NSDateExtension.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 21/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation
import UIKit

extension Date {
	var hour: CGFloat {
		get {
            let calendar = NSCalendar.current
			let components = calendar.components([.Hour, .Minute, .Second], fromDate: self)
			return CGFloat(3600 * components.hour + 60 * components.minute + components.second) / 3600.0
		}
	}
	var minute: CGFloat {
		get {
            let calendar = NSCalendar.current
			let components = calendar.components([.Minute, .Second], fromDate: self)
			return CGFloat(60 * components.minute + components.second) / 60.0
		}
	}
	var second: CGFloat {
		get {
            let calendar = NSCalendar.current
			let components = calendar.components([.Second], fromDate: self)
			return CGFloat(components.second)
		}
	}

	func isGreaterThanDate(dateToCompare : Date) -> Bool {
		//Declare Variables
		var isGreater = false
		
		//Compare Values
        if self.compare(dateToCompare) == ComparisonResult.OrderedDescending
		{
			isGreater = true
		}
		
		//Return Result
		return isGreater
	}
	
	
	func isLessThanDate(dateToCompare : Date) -> Bool {
		//Declare Variables
		var isLess = false
		
		//Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending
		{
			isLess = true
		}
		
		//Return Result
		return isLess
	}
	
	
	func addDays(daysToAdd : Int) -> Date	{
        let secondsInDays : TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded = self.addingTimeInterval(secondsInDays)
		
		//Return Result
		return dateWithDaysAdded
	}
	
	
	func addHours(hoursToAdd : Int) -> Date {
        let secondsInHours : TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded
            = self.addingTimeInterval(secondsInHours)
		
		//Return Result
		return dateWithHoursAdded
	}
}

extension TimeInterval {
	var days: Int {
		get {
			return Int(self) / (3600 * 24)
		}
	}
	var hour: Int {
		get {
			return (Int(self) % (3600 * 24)) / 3600
		}
	}
	var minute: Int {
		get {
			return (Int(self) % 3600) / 60
		}
	}
	var str: String {
		get {
			var flag = "+"
			if self < 0 {
				flag = "-"
			}
			
			var dayStr = ""
			if self.days != 0 {
				dayStr = String(days) + " days "
			}
			return flag + dayStr + String(abs(self.hour)) +  ":" + String(format: "%02d", abs(self.minute))
		}
	}
}
