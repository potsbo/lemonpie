//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit

class Pie: UIView {
	var pieces: [Piece] = []
	func addPiece(start: Double, end: Double){
		pieces.append(Piece(frame: frame, start: start, end: end))
	}

	override func drawRect(rect: CGRect) {
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
	
	var startDate = NSDate()
	var endDate = NSDate()
	
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
