//
//  ViewController.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let screenWidth = self.view.bounds.width
		let screenHeight = self.view.bounds.height
		let shorter = min(screenWidth, screenHeight)

		let pieClock = Pie(frame: CGRectMake((screenWidth - shorter)/2, (screenHeight - shorter)/2, shorter, shorter))
		let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
		
		let a = calendar.dateWithEra(1, year: 2015, month: 9, day: 20, hour: 1, minute: 0, second: 0, nanosecond: 0)!
		let b = calendar.dateWithEra(1, year: 2015, month: 9, day: 20, hour: 2, minute: 0, second: 0, nanosecond: 0)!
		let c = calendar.dateWithEra(1, year: 2015, month: 9, day: 20, hour: 9, minute: 0, second: 0, nanosecond: 0)!
		let d = calendar.dateWithEra(1, year: 2015, month: 9, day: 20, hour: 17, minute: 0, second: 0, nanosecond: 0)!

		pieClock.addPiece(a, end: b)
		pieClock.addPiece(c, end: d)
		pieClock.addHourHand(NSDate())

		self.view.addSubview(pieClock)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

