//
//  TimeDifferenceView.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 22/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation
import UIKit

class TimeDifferenceView: UIView {
	var timeLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.clearColor()
		timeLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
		timeLabel.text = ""
		timeLabel.textColor = UIColor.whiteColor()
		self.addSubview(timeLabel)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func startTimeTravel(){
		self.fadeIn(.Slow)
		timeLabel.text = "time travel"
	}
	func endTimeTravel(){
		self.fadeOut(.Normal)
	}
	
}