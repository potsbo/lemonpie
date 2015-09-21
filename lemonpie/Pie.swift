//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit
import EventKit

class Pie: UIView {
	var pieces: [Piece] = []
	var hourHand: Piece?
	var theme = ClockTheme()
	var isTimeTraveling = false
	var startDate = NSDate()

	var endDate: NSDate {
		return startDate.dateByAddingTimeInterval(12 * 60 * 60) // 12hours
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.startDate = NSDate()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	var radius: CGFloat {
		get {
			return self.frame.width*3/8
		}
	}
	
	func adjustHands(){
		if !isTimeTraveling {
			startDate = NSDate()
			hourHand?.redraw(startDate.hour, end: startDate.hour)
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
			self.layer.addSublayer(hourHand!.arc)
		}
		for piece in pieces {
			piece.draw()
			self.layer.addSublayer(piece.arc)
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
	var arc = CAShapeLayer()
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
		
		arc.lineWidth = 2
		arc.strokeColor = theme.titleLabelColor.CGColor
		arc.fillColor = nil
		
		let path = UIBezierPath(arcCenter: arcCenter, radius: self.radius,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
		path.addLineToPoint(arcCenter)
		path.closePath()
		
		arc.path = path.CGPath
	}
	
	func redraw(start: Double, end: Double) {
		self.startH = start
		self.endH = end
		self.draw()
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
