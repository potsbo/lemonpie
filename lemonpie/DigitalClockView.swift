//
//  DigitalClockView.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 24/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation
import UIKit

class DigitalClockView: UIView {
	var clockTime = NSDate() {
		didSet {
			timeLabel.text = String(format: "%02d",Int(floor(clockTime.hour))) + ":" + String(format: "%02d",Int(floor(clockTime.minute)))
		}
	}
	private var timeLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.clearColor()
		timeLabel = UILabel(frame: CGRectMake(21, 21, 200, 70))
		timeLabel.text = ""
		timeLabel.font = UIFont(name: "Helvetica", size: 35)
		timeLabel.textColor = UIColor.whiteColor()
		self.addSubview(timeLabel)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
