//
//  CushoningTime.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 25/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation

protocol TimeManageProtocol {
	func clockTimeChangedTo(newDate: Date)
}

class CushoningTime: NSObject {
	private var clockTime: Date{
		didSet {
            delegate?.clockTimeChangedTo(newDate: clockTime)
		}
	}
	private var targetClockTime: Date
	private var startClockTime: Date
	var delegate: TimeManageProtocol?
	var timer: Timer?
	var time: Date {
		return clockTime
	}
	
	init(date: Date = Date()){
		targetClockTime = date
		startClockTime = targetClockTime
		clockTime = targetClockTime
	}
	
	func setNewTime(newTime: Date, force: Bool = false){
		self.timer?.invalidate()
		self.timer = nil
		print("\(targetClockTime.hour)")
		targetClockTime = newTime
		startClockTime = clockTime
        if force || abs(clockTime.timeIntervalSince(targetClockTime)) < 10 {
			clockTime = targetClockTime
		} else {
            self.timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: "update:", userInfo: nil, repeats: true)
		}
	}
	
	func dateByAddingTimeInterval(interval: TimeInterval, force: Bool){
		if force {
            clockTime = clockTime.addingTimeInterval(interval)
			targetClockTime = clockTime
		} else {
            
            setNewTime(newTime: clockTime.addingTimeInterval(interval))
		}
	}
	
	func update(timer: Timer){
        if abs(clockTime.timeIntervalSince(targetClockTime)) < 10 {
			self.timer?.invalidate()
			clockTime = targetClockTime
        } else if self.timer?.isValid == true {
			
            let totalInterval = clockTime.timeIntervalSince(targetClockTime)
			let frameInterval: TimeInterval = totalInterval/15
			clockTime = clockTime.addingTimeInterval(-frameInterval)
		}
	}
}
