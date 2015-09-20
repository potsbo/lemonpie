//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit

extension NSDate {
	var hour: Double {
		get {
			let calendar = NSCalendar.currentCalendar()
			let components = calendar.components([.Hour, .Minute], fromDate: self)
			return Double(60 * components.hour + components.minute) / 60.0
		}
	}
	var minute: Double {
		get {
			let calendar = NSCalendar.currentCalendar()
			let components = calendar.components([.Minute, .Second], fromDate: self)
			return Double(60 * components.minute + components.second) / 60.0
		}
	}
}

class ClockTheme {
//TODO
}

class Pie: UIView {
	var pieces: [Piece] = []
	var hourHand: Piece?
	
	func addPiece(start: NSDate, end: NSDate){
		pieces.append(Piece(frame: frame, start: start.hour, end: end.hour))
	}

	func addHourHand(now: NSDate){
		hourHand = Piece(frame: frame, start: now.hour, end: now.hour)
	}
	
	func theme(theme: ClockTheme?){
		if theme != nil {
		//TODO
		} else {
			self.backgroundColor = UIColor.clearColor()
		}
	}
	
	override func drawRect(rect: CGRect) {
		if hourHand != nil {
			hourHand!.draw()
		}
		for piece in pieces {
			piece.draw()
		}
	}
}

class Piece {
	var startH: Double
	var endH: Double
	var frame: CGRect
	init(frame: CGRect, start: Double, end: Double){
		self.frame = frame
		self.startH = start
		self.endH = end
	}
	
	var startAngle: CGFloat {
		get {
			return CGFloat(-M_PI/2 + M_PI * startH/6)
		}
	}
	var endAngle: CGFloat {
		get {
			return CGFloat(-M_PI/2 + M_PI * endH/6)
		}
	}
	
	var arcCenter: CGPoint {
		get {
			return CGPointMake(self.frame.width/2, self.frame.height/2)
		}
	}
	
	
	func draw() {
		
		let arc = UIBezierPath(arcCenter: arcCenter, radius: self.frame.width*3/8,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
		arc.addLineToPoint(arcCenter)
		arc.closePath()
		let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
		aColor.setStroke()
		arc.lineWidth = 2
		arc.stroke()
	}
	
}
