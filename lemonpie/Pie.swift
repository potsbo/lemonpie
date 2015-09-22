//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit
import EventKit

private let π = CGFloat(M_PI)

protocol PieDelegate {
	func startTimeTravel()
	func endTimeTravel()
	func timeDifferenceDidChange()
}

class Pie: UIView {
	var pieces: [Piece] = []
	var hourHand: ClockHand!
	var secondHand: Piece?
	var theme = ClockTheme()
	var viewController = UIViewController()
	var delegate: PieDelegate!
	var startDate = NSDate() {
		didSet {
			adjustHands()
			adjustPiecesInside()
			putIndexes()
		}
	}
	
	var indexLabels: [UILabel] = []

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
		hourHand?.time = startDate
		hourHand?.draw()
	}
	
	func adjustPiecesInside(){
		for piece in pieces {
			piece.redraw()
		}
	}
	
	func addPiece(event: EKEvent){
		pieces.append(Piece(frame: frame, event: event, superview: self))
	}

	func addHourHand(now: NSDate){
		hourHand = ClockHand(type: .hour, time: now, superview: self)
	}
	
	func setTheme(theme: ClockTheme) {
		self.theme = theme
	}
	
	func applyTheme(){

		self.backgroundColor = self.theme.pieBackColor
		putIndexes()
		
	}
	
	func putIndexes() {
		for label in indexLabels {
			label.removeFromSuperview()
		}
		indexLabels = []
		
		let nearest = Int(ceil(startDate.hour))
		for var i = nearest; i < nearest + 12; i++ {
			var indexRaw = i
			if i > 24 {
				indexRaw = i % 24
			}
			
			let indexNum = indexRaw
			
			if theme.isToShow(indexNum) {
				let index = (indexNum + 9) % 12
				let x = CGFloat(cos(π * CGFloat(index) / 6)) * (radius + self.theme.indexPadding)
				let y = CGFloat(sin(π * CGFloat(index) / 6)) * (radius + self.theme.indexPadding)
				let indexLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
				indexLabel.center = CGPointMake(x + self.frame.width/2, y + self.frame.height/2)
				indexLabel.textAlignment = NSTextAlignment.Center
				indexLabel.text = String(indexNum)
				indexLabel.textColor = self.theme.indexColor
				self.addSubview(indexLabel)
				self.indexLabels.append(indexLabel)
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
	
	var superview: Pie
	
	var startDate: NSDate
	var endDate: NSDate
	
	var isToShow: Bool {
		return endDate.isGreaterThanDate(superview.startDate) &&
			startDate.isLessThanDate(superview.endDate)
	}
	

	
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
	
	init(frame: CGRect, event: EKEvent, superview: Pie){
		self.frame = frame
		self.startDate = event.startDate
		self.endDate = event.endDate
		self.title = event.title
		self.event = event
		self.superview = superview
	}

	var drawStartDate: NSDate {
		if superview.startDate.isGreaterThanDate(self.startDate) {
			return superview.startDate
		}
		return self.startDate
	}
	
	var drawEndDate: NSDate {
		get {
			if superview.endDate.isLessThanDate(self.endDate) {
				return superview.endDate
			}
			return self.endDate
		}
	}
	
	var startAngle: CGFloat {
		get {
			return getAngle(drawStartDate.hour)
		}
	}
	var endAngle: CGFloat {
		get {
			return getAngle(drawEndDate.hour)
		}
	}
	
	var arcCenter: CGPoint {
		get {
			return CGPointMake(self.frame.width/2, self.frame.height/2)
		}
	}
	
	var midH: Double {
		get {
			return (drawStartDate.hour + drawEndDate.hour)/2
		}
	}
	
	var midAngle: CGFloat {
		get {
			return getAngle(midH)
		}
	}
	
	func getAngle(hour: Double) -> CGFloat {
		return -π/2 + π * CGFloat(hour/6)
	}
	
	func draw() {
		if isToShow {
			arc.lineWidth = 2
			arc.strokeColor = theme.titleLabelColor.CGColor
			arc.fillColor = nil
			
			let path = UIBezierPath(arcCenter: arcCenter, radius: self.radius,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
			path.addLineToPoint(arcCenter)
			path.closePath()
			
			arc.path = path.CGPath
		}
		
	}
	
	func redraw() {
		arc.path = nil
		self.adjustTitle()
		if isToShow {
			self.draw()
		}
	}
	
	func adjustTitle() {
		if isToShow {
			let x = cos(midAngle) * self.radius + self.frame.width/2
			let y = sin(midAngle) * self.radius + self.frame.height/2
			let midPoint = CGPointMake(x, y)
			
			titleLabel?.center = CGPointMake((arcCenter.x + 2*midPoint.x)/3, (arcCenter.y + 2*midPoint.y)/3)
			titleLabel?.textColor = theme.titleLabelColor
			
			if -π/6 < midAngle && midAngle < 0 {
				titleLabel?.center = CGPointMake((titleLabel?.center.x)!, (titleLabel?.center.y)! + theme.indexPadding/3)
			} else if 0 < midAngle && midAngle < π/6 {
				titleLabel!.center = CGPointMake((titleLabel?.center.x)!, (titleLabel?.center.y)! - theme.indexPadding/3)
			} else if midAngle < 7*π/6 && midAngle > 5*π/6 {
				
			} else {
				if midAngle > π/2 {
					titleLabel?.transform = CGAffineTransformMakeRotation(midAngle+π);
				} else {
					titleLabel?.transform = CGAffineTransformMakeRotation(midAngle);
				}
			}
			
			titleLabel?.textAlignment = NSTextAlignment.Center
			titleLabel?.hidden = false
		} else {
			titleLabel?.hidden = true
		}
		
	
	}
	
	func showTitle(){
		if title != nil {
			titleLabel = nil
			titleLabel = UILabel(frame: CGRectMake(0, 0, 200, theme.indexPadding))
			titleLabel!.text = title
			titleLabel!.hidden = false
			
			adjustTitle()
		}
	}
	
}
