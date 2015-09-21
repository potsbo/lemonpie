//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit
import EventKit

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
	var lineColor = UIColor.whiteColor()
	var pieBackColor = UIColor.clearColor()
	var indexColor = UIColor.whiteColor()
	var indexBitMask: Int
	var is24h = true
	var titleLabelColor = UIColor.whiteColor()
	func isToShow(index: Int) -> Bool{
		if (self.indexBitMask & (1 << (index % 12))) >> (index % 12) == 1 {
			return true
		}
		return false
	}
	var indexPadding: CGFloat = 21
	
	init() {
		indexBitMask = 0
		self.indexEvery(1)
	}
	
	func indexEvery(num: Int) {
		self.indexBitMask = 0
		for var i = 0; i < 12; i += num {
			self.indexBitMask += 0b1 << i
		}
	}
}

class Pie: UIView {
	var pieces: [Piece] = []
	var hourHand: Piece?
	var theme = ClockTheme()
	var startDate = NSDate()

	var radius: CGFloat {
		get {
			return self.frame.width*3/8
		}
	}
	
	func addPiece(event: EKEvent){
		pieces.append(Piece(frame: frame, event: event))
	}

	func addHourHand(now: NSDate){
		hourHand = Piece(frame: frame, start: now.hour, end: now.hour)
	}
	
	func setTheme(theme: ClockTheme) {
		self.theme = theme
	}
	
	func applyTheme(){

		self.backgroundColor = self.theme.pieBackColor
		let nearest = Int(ceil(NSDate().hour))
		for var i = nearest; i < nearest + 12; i++ {
			var indexRaw = i
			if i > 24 {
				indexRaw = i % 24
			}
			
			let indexNum = indexRaw
			
			if theme.isToShow(indexNum) {
				let index = (indexNum + 9) % 12
				let x = CGFloat(cos(M_PI * Double(index) / 6)) * (radius + self.theme.indexPadding)
				let y = CGFloat(sin(M_PI * Double(index) / 6)) * (radius + self.theme.indexPadding)
				let indexLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
				indexLabel.center = CGPointMake(x + self.frame.width/2, y + self.frame.height/2)
				indexLabel.textAlignment = NSTextAlignment.Center
				indexLabel.text = String(indexNum)
				indexLabel.textColor = self.theme.indexColor
				self.addSubview(indexLabel)
			}
		}
		
	}
	
	override func drawRect(rect: CGRect) {
		if hourHand != nil {
			hourHand!.draw()
		}
		for piece in pieces {
			piece.draw()
			piece.showTitle()
			self.addSubview(piece.titleLabel!)
		}
	}
}

class Piece {
	var startH: Double
	var endH: Double
	var frame: CGRect
	var title: String?
	var titleLabel: UILabel?
	var event: EKEvent?
	var theme = ClockTheme()
	var radius: CGFloat {
		get {
			return self.frame.width*3/8
		}
	}
	
	init(frame: CGRect, event: EKEvent){
		self.frame = frame
		self.startH = event.startDate.hour
		self.endH = event.endDate.hour
		self.title = event.title
		self.event = event
	}
	init(frame: CGRect, start: Double, end: Double){
		self.frame = frame
		self.startH = start
		self.endH = end
	}
	
	var startAngle: CGFloat {
		get {
			return getAngle(startH)
		}
	}
	var endAngle: CGFloat {
		get {
			return getAngle(endH)
		}
	}
	
	var arcCenter: CGPoint {
		get {
			return CGPointMake(self.frame.width/2, self.frame.height/2)
		}
	}
	
	var midH: Double {
		get {
			return (startH + endH)/2
		}
	}
	
	var midAngle: CGFloat {
		get {
			return getAngle(midH)
		}
	}
	
	func getAngle(hour: Double) -> CGFloat {
		return CGFloat(-M_PI/2 + M_PI * hour/6)
	}
	
	func draw() {
		let arc = UIBezierPath(arcCenter: arcCenter, radius: self.radius,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
		arc.addLineToPoint(arcCenter)
		arc.closePath()
		let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
		aColor.setStroke()
		arc.lineWidth = 2
		arc.stroke()
	}
	
	func showTitle(){
		if title != nil {
			print(midAngle)
			print(cos(midAngle))
			print(sin(midAngle))
			let x = CGFloat(cos(midAngle)) * self.radius + self.frame.width/2
			let y = CGFloat(sin(midAngle)) * self.radius + self.frame.height/2
			let midPoint = CGPointMake(x, y)
			
			titleLabel = UILabel(frame: CGRectMake(0, 0, 200, theme.indexPadding))
			
			
			titleLabel!.text = title
			titleLabel!.center = CGPointMake((arcCenter.x + 2*midPoint.x)/3, (arcCenter.y + 2*midPoint.y)/3)
			titleLabel!.textColor = theme.titleLabelColor
			
			if midAngle < CGFloat(M_PI)/6 && midAngle > -CGFloat(M_PI)/6 {
				titleLabel!.center = CGPointMake(titleLabel!.center.x, titleLabel!.center.y + theme.indexPadding/3)
			} else if midAngle < CGFloat(7*M_PI)/6 && midAngle > CGFloat(5*M_PI)/6 {
				
			} else {
				if midAngle > CGFloat(M_PI_2) {
					titleLabel!.transform = CGAffineTransformMakeRotation(midAngle+CGFloat(M_PI));
				} else {
					titleLabel!.transform = CGAffineTransformMakeRotation(midAngle);
				}
			}
			
			titleLabel!.textAlignment = NSTextAlignment.Center
		}
	}
	
}
