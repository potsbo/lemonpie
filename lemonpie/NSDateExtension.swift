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
}