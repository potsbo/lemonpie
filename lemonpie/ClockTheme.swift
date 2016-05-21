//
//  ClockTheme.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 21/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import Foundation
import UIKit

class ClockTheme { //Singleton
	
	static let sharedInstance = ClockTheme()
	
	private(set) var lineColor = UIColor.whiteColor()
	private(set) var pieBackColor = UIColor.clearColor()
	private(set) var indexColor = UIColor.whiteColor()
	private(set) var indexBitMask: Int = 0
	private(set) var is24h = true
	private(set) var titleLabelColor = UIColor.whiteColor()
	private(set) var indexPadding: CGFloat = 21
	
	private init() {
		self.indexEvery(1)
	}
	
	func isToShow(index: Int) -> Bool{
		if (self.indexBitMask & (1 << (index % 12))) >> (index % 12) == 1 {
			return true
		}
		return false
	}
	
	func indexEvery(num: Int) {
		self.indexBitMask = 0
		for var i = 0; i < 12; i += num {
			self.indexBitMask += 0b1 << i
		}
	}
}