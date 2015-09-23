//
//  NSDateExtension.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 21/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation

extension NSDate {
	var hour: Double {
		get {
			let calendar = NSCalendar.currentCalendar()
			let components = calendar.components([.Hour, .Minute, .Second], fromDate: self)
			return Double(3600 * components.hour + 60 * components.minute + components.second) / 3600.0
		}
	}
	var minute: Double {
		get {
			let calendar = NSCalendar.currentCalendar()
			let components = calendar.components([.Minute, .Second], fromDate: self)
			return Double(60 * components.minute + components.second) / 60.0
		}
	}
	var second: Double {
		get {
			let calendar = NSCalendar.currentCalendar()
			let components = calendar.components([.Second], fromDate: self)
			return Double(components.second)
		}
	}

	func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
		//Declare Variables
		var isGreater = false
		
		//Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
		{
			isGreater = true
		}
		
		//Return Result
		return isGreater
	}
	
	
	func isLessThanDate(dateToCompare : NSDate) -> Bool {
		//Declare Variables
		var isLess = false
		
		//Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
		{
			isLess = true
		}
		
		//Return Result
		return isLess
	}
	
	
	func addDays(daysToAdd : Int) -> NSDate	{
		let secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
		let dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
		
		//Return Result
		return dateWithDaysAdded
	}
	
	
	func addHours(hoursToAdd : Int) -> NSDate {
		let secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
		let dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
		
		//Return Result
		return dateWithHoursAdded
	}
}

extension NSTimeInterval {
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