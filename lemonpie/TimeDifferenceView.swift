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
	private var timeLabel = UILabel()
    var timeDifference: TimeInterval = 0 {
		didSet {
			timeLabel.text = timeDifference.str
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
        backgroundColor = UIColor.clear
		timeLabel = UILabel(frame: CGRectMake(21, 21, 200, 70))
		timeLabel.text = ""
		timeLabel.font = UIFont(name: "Helvetica", size: 35)
        timeLabel.textColor = UIColor.white
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
