//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit
import EventKit

private let π = CGFloat(Double.pi)

protocol PieDelegate {
	func startTimeTravel()
    func timeTravelByInterval(interval: TimeInterval)
	func endTimeTravel()
	func timeDifferenceDidChange()
}

protocol PieceDelegate {
	func getRadius(midDate: Date)-> CGFloat
    func getTimeRemainingUntil(midDate: Date)-> TimeInterval
	func getAngleForHour(hour: CGFloat) -> CGFloat
	func getAlpha(hour: Date) -> CGFloat
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
	
	var startDate = Date() {
		didSet {
			adjustHands()
			adjustPiecesInside()
			putIndexes()
		}
	}
	override var frame: CGRect {
		didSet{
            oneFingerRotation?.midPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
		}
	}
	
	var oneFingerRotation: XMCircleGestureRecognizer?
	var indexLabels: [UILabel] = []

	var endDate: Date {
        return startDate.addingTimeInterval(Double(showSeconds))
	}
	
	override init(frame: CGRect) {

		super.init(frame: frame)
		

		self.startDate = Date()
		
        self.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
		print(self.center)
		
        oneFingerRotation = XMCircleGestureRecognizer(midPoint: super.center, target: self, action: Selector("rotateGesture:"))
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
	
	func getRadius(midDate: Date) -> CGFloat {
        return self.radius - CGFloat(midDate.timeIntervalSince(startDate))/3600 * 5
	}
	
	func getAngleForHour(hour: CGFloat) -> CGFloat {
		return 2*π / CGFloat(showHours) * CGFloat(hour) - π/2
	}
	
    func getTimeRemainingUntil(midDate: Date) -> TimeInterval {
        return midDate.timeIntervalSince(startDate)
	}
	
	func getAlpha(hour: Date) -> CGFloat {
        return 1 - CGFloat(getTimeRemainingUntil(midDate: hour)/Double(showSeconds))
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
		pieces.append(newPiece)
	}

	func addHourHand(now: Date){
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
        for i in (nearest..<(nearest+showHours)) {
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
                let indexLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                indexLabel.center = CGPoint(x: x + self.frame.width/2, y: y + self.frame.height/2)
                indexLabel.textAlignment = NSTextAlignment.center
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
            delegate.timeTravelByInterval(interval: TimeInterval(rotation.degrees*10 * CGFloat(showHours)))
		}
	}

}

private class Piece {
	
	private var superview: Pie
	
	private var startDate: Date
	private var endDate: Date
	private var delegate: PieceDelegate?
	
	private var isToShow: Bool {
        return endDate.isGreaterThanDate(dateToCompare: superview.startDate) &&
            startDate.isLessThanDate(dateToCompare: superview.endDate)
	}
	
	private var frame: CGRect
	private var title: String?
	private(set) var titleLabel: UILabel?
	private var event: EKEvent?
	private(set) var arc = CAShapeLayer()
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
        self.delegate = superview
	}

	private var drawStartDate: Date {
        if superview.startDate.isGreaterThanDate(dateToCompare: self.startDate) {
			return superview.startDate
		}
		return self.startDate
	}
	
	private var drawEndDate: Date {
		get {
            if superview.endDate.isLessThanDate(dateToCompare: self.endDate) {
				return superview.endDate
			}
			return self.endDate
		}
	}
	
	private var startAngle: CGFloat {
		get {
            return getAngle(hour: drawStartDate.hour)
		}
	}
	private var endAngle: CGFloat {
		get {
            return getAngle(hour: drawEndDate.hour)
		}
	}
	
	private var arcCenter: CGPoint {
		get {
            return CGPoint(x: self.frame.width/2, y: self.frame.height/2)
		}
	}
	
	private var drawMidDate: Date {
		get {
            return drawStartDate.addingTimeInterval(drawEndDate.timeIntervalSince(drawStartDate)/2)
		}
	}
	
	private var midAngle: CGFloat {
		get {
            return getAngle(hour: drawMidDate.hour)
		}
	}
	
	private func getAngle(hour: CGFloat) -> CGFloat {
        return (delegate?.getAngleForHour(hour: hour))!
	}
	
	func draw() {
		if isToShow {
			arc.lineWidth = 2
            arc.strokeColor = ClockTheme.sharedInstance.titleLabelColor.cgColor
			arc.fillColor = nil
			
			let path = UIBezierPath(arcCenter: arcCenter, radius: self.radius,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: arcCenter)
            path.close()
			
            arc.path = path.cgPath
            arc.opacity = Float((delegate?.getAlpha(hour: startDate))!)
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
            let midPoint = CGPoint(x: x, y: y)
			
            titleLabel?.center = CGPoint(x: (arcCenter.x + 2*midPoint.x)/3, y: (arcCenter.y + 2*midPoint.y)/3)
			titleLabel?.textColor = ClockTheme.sharedInstance.titleLabelColor
			
			if -π/6 < midAngle && midAngle < 0 {
                titleLabel?.center = CGPoint(x: (titleLabel?.center.x)!, y: (titleLabel?.center.y)! + ClockTheme.sharedInstance.indexPadding/3)
			} else if 0 < midAngle && midAngle < π/6 {
                titleLabel!.center = CGPoint(x: (titleLabel?.center.x)!, y: (titleLabel?.center.y)! - ClockTheme.sharedInstance.indexPadding/3)
			} else if midAngle < 7*π/6 && midAngle > 5*π/6 {
				
			} else {
				if midAngle > π/2 {
                    titleLabel?.transform = CGAffineTransform(rotationAngle: midAngle+π);
				} else {
                    titleLabel?.transform = CGAffineTransform(rotationAngle: midAngle);
				}
			}
			
            titleLabel?.textAlignment = NSTextAlignment.center
            titleLabel?.isHidden = false
            titleLabel?.alpha = (delegate?.getAlpha(hour: startDate))!

		} else {
            titleLabel?.isHidden = true
		}
		
	
	}
	
	func showTitle(){
		if title != nil {
			titleLabel = nil
            titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: ClockTheme.sharedInstance.indexPadding))
			titleLabel!.text = title
            titleLabel!.isHidden = false
			
			adjustTitle()
		}
	}
	
}
