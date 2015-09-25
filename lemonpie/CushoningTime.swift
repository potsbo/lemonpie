//
//  CushoningTime.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 25/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation

protocol TimeManageProtocol {
	func clockTimeChangedTo(newDate: NSDate)
}

class CushoningTime: NSObject {
	private var clockTime: NSDate{
		didSet {
			delegate?.clockTimeChangedTo(clockTime)
		}
	}
	private var targetClockTime: NSDate
	private var startClockTime: NSDate
	var delegate: TimeManageProtocol?
	var timer: NSTimer?
	var time: NSDate {
		return clockTime
	}
	
	init(date: NSDate = NSDate()){
		targetClockTime = date ?? NSDate()
		startClockTime = targetClockTime
		clockTime = targetClockTime
	}
	
	func setNewTime(newTime: NSDate, force: Bool = false){
		self.timer?.invalidate()
		self.timer = nil
		print("\(targetClockTime.hour)")
		targetClockTime = newTime
		startClockTime = clockTime
		if force || abs(clockTime.timeIntervalSinceDate(targetClockTime)) < 10 {
			clockTime = targetClockTime
		} else {
			self.timer = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: "update:", userInfo: nil, repeats: true)
		}
	}
	
	func dateByAddingTimeInterval(interval: NSTimeInterval, force: Bool){
		if force {
			clockTime = clockTime.dateByAddingTimeInterval(interval)
			targetClockTime = clockTime
		} else {
			setNewTime(clockTime.dateByAddingTimeInterval(interval))
		}
	}
	
	func update(timer: NSTimer){
		if abs(clockTime.timeIntervalSinceDate(targetClockTime)) < 10 {
			self.timer?.invalidate()
			clockTime = targetClockTime
		} else if self.timer?.valid == true {
			
			let totalInterval = clockTime.timeIntervalSinceDate(targetClockTime)
			let frameInterval: NSTimeInterval = totalInterval/15
			clockTime = clockTime.dateByAddingTimeInterval(-frameInterval)
		}
	}
}