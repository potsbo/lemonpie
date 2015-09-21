//
//  ClockTheme.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 21/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation
import UIKit

class ClockTheme {
	var lineColor = UIColor.whiteColor()
	var pieBackColor = UIColor.clearColor()
	var indexColor = UIColor.whiteColor()
	var indexBitMask: Int
	var is24h = true
	var titleLabelColor = UIColor.whiteColor()
	func isToShow(index: Int) -> Bool{
		if (self.indexBitMask & (1 << (index % 12))) >> (index % 12) == 1 {
			return true
		}
		return false
	}
	var indexPadding: CGFloat = 21
	
	init() {
		indexBitMask = 0
		self.indexEvery(1)
	}
	
	func indexEvery(num: Int) {
		self.indexBitMask = 0
		for var i = 0; i < 12; i += num {
			self.indexBitMask += 0b1 << i
		}
	}
}
