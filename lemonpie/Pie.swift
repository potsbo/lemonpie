//
//  Pie.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit

class Pie: UIView {
	
	var startH = 1.0
	var endH = 4.0
	
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

	override func drawRect(rect: CGRect) {
		
		let arc = UIBezierPath(arcCenter: arcCenter, radius: self.frame.width*3/8,  startAngle: startAngle, endAngle: endAngle, clockwise: true)
		arc.addLineToPoint(arcCenter)
		arc.closePath()
		let aColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
		aColor.setStroke()
		arc.lineWidth = 2
		arc.stroke()
	}

}
