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
	var clockTime = Date() {
		didSet {
			timeLabel.text = String(format: "%02d",Int(floor(clockTime.hour))) + ":" + String(format: "%02d",Int(floor(clockTime.minute)))
		}
	}
	private var timeLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
        backgroundColor = UIColor.clear
        timeLabel = UILabel(frame: CGRect(x: 21, y: 21, width: 200, height: 70))
		timeLabel.text = ""
		timeLabel.font = UIFont(name: "Helvetica", size: 35)
        timeLabel.textColor = UIColor.white
		self.addSubview(timeLabel)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
