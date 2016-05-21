//
//  ClockHand.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 23/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation
import UIKit

private let π = CGFloat(M_PI)

enum ClockHandType {
	case hour, minute, second
}

class ClockHand {
	var type: ClockHandType
	var time: NSDate
	var arc = CAShapeLayer()
	var clock: Pie!
	var length: CGFloat {
		get {
			return self.clock.frame.width*3/8
		}
	}
	

	
	init(type: ClockHandType, time: NSDate, superview: Pie) {
		self.type = type
		self.time = time
		self.clock = superview
	}
	
	func getAngle(hour: CGFloat) -> CGFloat {
		return -π/2 + π * CGFloat(hour/6)
	}
	
	var angle: CGFloat {
		get {
			return getAngle(self.time.hour)
		}
	}
	
	var arcCenter: CGPoint {
		get {
			return CGPointMake(self.clock.frame.width/2, self.clock.frame.height/2)
		}
	}
	
	func draw() {
		arc.lineWidth = 2
		arc.strokeColor = self.clock.theme.titleLabelColor.CGColor
		arc.fillColor = nil
		
		let path = UIBezierPath(arcCenter: arcCenter, radius: self.length,  startAngle: angle, endAngle: angle, clockwise: true)
		path.addLineToPoint(arcCenter)
		path.closePath()
		
		arc.path = path.CGPath
	}
	
}