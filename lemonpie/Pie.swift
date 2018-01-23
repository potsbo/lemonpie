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
    func timeTravelByInterval(interval: TimeInterval)
	func endTimeTravel()
	func timeDifferenceDidChange()
}

protocol PieceDelegate {
	func getRadius(midDate: NSDate)-> CGFloat
    func getTimeRemainingUntil(midDate: NSDate)-> TimeInterval
	func getAngleForHour(hour: CGFloat) -> CGFloat
	func getAlpha(hour: NSDate) -> CGFloat
}

class Pie: UIView, PieceDelegate {
	private var pieces: [Piece] = []
	var hourHand: ClockHand!
	var theme = ClockTheme.sharedInstance
	var viewController = UIViewController()
	var delegate: PieDelegate!
	var showHours = 12
	var showSeconds: Int {
		return showHours * 3600
	}
	
	var startDate = NSDate() {
		didSet {
			adjustHands()
			adjustPiecesInside()
			putIndexes()
		}
	}
	override var frame: CGRect {
		didSet{
			oneFingerRotation?.midPoint = CGPointMake(self.frame.width/2, self.frame.height/2)
		}
	}
	
	var oneFingerRotation: XMCircleGestureRecognizer?
	var indexLabels: [UILabel] = []

	var endDate: NSDate {
        return startDate.addingTimeInterval(Double(showSeconds))
	}
	
	override init(frame: CGRect) {

		super.init(frame: frame)
		

		self.startDate = NSDate()
		
        self.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
		print(self.center)
		
		oneFingerRotation = XMCircleGestureRecognizer(midPoint: super.center, target: self, action: "rotateGesture:")
		self.addGestureRecognizer(oneFingerRotation!)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	var radius: CGFloat {
		get {
			return self.frame.width*3/8
		}
	}
	
	func getRadius(midDate: NSDate) -> CGFloat {
		return self.radius - CGFloat(midDate.timeIntervalSinceDate(startDate))/3600 * 5
	}
	
	func getAngleForHour(hour: CGFloat) -> CGFloat {
		return 2*π / CGFloat(showHours) * CGFloat(hour) - π/2
	}
	
    func getTimeRemainingUntil(midDate: NSDate) -> TimeInterval {
		return midDate.timeIntervalSinceDate(startDate)
	}
	
	func getAlpha(hour: NSDate) -> CGFloat {
		return 1 - CGFloat(getTimeRemainingUntil(hour)/Double(showSeconds))
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
		let newPiece = Piece(frame: frame, event: event, superview: self)
		newPiece.delegate = self
		pieces.append(newPiece)
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
		for var i = nearest; i < nearest + showHours; i++ {
			var indexRaw = i
			if i > 24 {
				indexRaw = i % 24
			}
			
			let indexNum = indexRaw
			
            if theme.isToShow(index: indexNum) {
				let index = indexNum % 24
                let angle = getAngleForHour(hour: CGFloat(index))
				let x = CGFloat(cos(angle)) * (radius + self.theme.indexPadding)
				let y = CGFloat(sin(angle)) * (radius + self.theme.indexPadding)
				let indexLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
                indexLabel.center = CGPoint(x: x + self.frame.width/2, y: y + self.frame.height/2)
				indexLabel.textAlignment = NSTextAlignment.Center
				indexLabel.text = String(indexNum)
				indexLabel.textColor = self.theme.indexColor
				self.addSubview(indexLabel)
				self.indexLabels.append(indexLabel)
			}
		}
	}
	
    override func draw(_ rect: CGRect) {
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
	
	func rotateGesture(recognizer: XMCircleGestureRecognizer) {
		if let rotation = recognizer.rotation {
			delegate.startTimeTravel()
            delegate.timeTravelByInterval(TimeInterval(rotation.degrees*10 * CGFloat(showHours)))
		}
	}

}

private class Piece {
	
	private var superview: Pie
	
	private var startDate: NSDate
	private var endDate: NSDate
	private var delegate: PieceDelegate?
	
	private var isToShow: Bool {
        return endDate.isGreaterThanDate(dateToCompare: superview.startDate) &&
			startDate.isLessThanDate(superview.endDate)
	}
	
	private var frame: CGRect
	private var title: String?
	private var titleLabel: UILabel?
	private var event: EKEvent?
	private var arc = CAShapeLayer()
	private var radius: CGFloat {
		get {
            return delegate?.getRadius(midDate: drawMidDate) ?? self.frame.width * 3/8
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

	private var drawStartDate: NSDate {
		if superview.startDate.isGreaterThanDate(self.startDate) {
			return superview.startDate
		}
		return self.startDate
	}
	
	private var drawEndDate: NSDate {
		get {
			if superview.endDate.isLessThanDate(self.endDate) {
				return superview.endDate
			}
			return self.endDate
		}
	}
	
	private var startAngle: CGFloat {
		get {
			return getAngle(drawStartDate.hour)
		}
	}
	private var endAngle: CGFloat {
		get {
			return getAngle(drawEndDate.hour)
		}
	}
	
	private var arcCenter: CGPoint {
		get {
			return CGPointMake(self.frame.width/2, self.frame.height/2)
		}
	}
	
	private var drawMidDate: NSDate {
		get {
			return drawStartDate.dateByAddingTimeInterval(drawEndDate.timeIntervalSinceDate(drawStartDate)/2)
		}
	}
	
	private var midAngle: CGFloat {
		get {
			return getAngle(drawMidDate.hour)
		}
	}
	
	private func getAngle(hour: CGFloat) -> CGFloat {
		return (delegate?.getAngleForHour(hour))!
	}
	
	func draw() {
		if isToShow {
			arc.lineWidth = 2
			arc.strokeColor = ClockTheme.sharedInstance.titleLabelColor.CGColor
			arc.fillColor = nil
			
			let path = UIBezierPath(arcCenter: arcCenter, radius: self.radius,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
			path.addLineToPoint(arcCenter)
			path.closePath()
			
			arc.path = path.CGPath
			arc.opacity = Float((delegate?.getAlpha(startDate))!)
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
			titleLabel?.textColor = ClockTheme.sharedInstance.titleLabelColor
			
			if -π/6 < midAngle && midAngle < 0 {
				titleLabel?.center = CGPointMake((titleLabel?.center.x)!, (titleLabel?.center.y)! + ClockTheme.sharedInstance.indexPadding/3)
			} else if 0 < midAngle && midAngle < π/6 {
				titleLabel!.center = CGPointMake((titleLabel?.center.x)!, (titleLabel?.center.y)! - ClockTheme.sharedInstance.indexPadding/3)
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
			titleLabel?.alpha = (delegate?.getAlpha(startDate))!

		} else {
			titleLabel?.hidden = true
		}
		
	
	}
	
	func showTitle(){
		if title != nil {
			titleLabel = nil
			titleLabel = UILabel(frame: CGRectMake(0, 0, 200, ClockTheme.sharedInstance.indexPadding))
			titleLabel!.text = title
			titleLabel!.hidden = false
			
			adjustTitle()
		}
	}
	
}
