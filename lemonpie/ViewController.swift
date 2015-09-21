//
//  ViewController.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
	
	let eventStore = EKEventStore()
	let pieClock = Pie(frame: CGRectMake(0,0,0,0))
	var isTimeTraveling = false
	var shorter:CGFloat {
		get {
			return min(screenWidth, screenHeight)
		}
	}
	var longer:CGFloat {
		get {
			return max(screenWidth, screenHeight)
		}
	}
	var screenWidth: CGFloat {
		return self.view.bounds.width
	}
	var screenHeight: CGFloat {
		return self.view.bounds.height
	}
	
	override func viewWillAppear(animated: Bool) {
		checkCalendarAuthorizationStatus()
	}
	let excludeAllDay = true
	
	func initialize(){
		
	}
	
	func update(){
		
	}
	
	func checkCalendarAuthorizationStatus() {
		let status = EKEventStore.authorizationStatusForEntityType(.Event)
		
		switch (status) {
		case EKAuthorizationStatus.NotDetermined:
			// This happens on first-run
			requestAccessToCalendar()
		case EKAuthorizationStatus.Authorized:
			// Things are in line with being able to show the calendars in the table view
			loadPie()
			readEvents()
//			refreshTableView()
			break
		case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
			// We need to help them give us permission
			//needPermissionView.fadeIn()
			break
		}
	}

	func requestAccessToCalendar() {
		eventStore.requestAccessToEntityType(.Event, completion: handler)
	}
	func handler(granted: Bool, error: NSError?) {
	// put your handler code here
	}
	
	func readEvents(){
		
		/* Instantiate the event store */
		let eventStore = EKEventStore()
		
		/* The event starts from today, right now */
		let startDate = NSDate()
		
		/* The end date will be 1 day from today */
		let endDate = startDate.dateByAddingTimeInterval(12 * 60 * 60)
		
		/* Create the predicate that we can later pass to the
		event store in order to fetch the events */
		let searchPredicate = eventStore.predicateForEventsWithStartDate(
			startDate,
			endDate: endDate, calendars: nil)
		
		/* Fetch all the events that fall between
		the starting and the ending dates */
		let events = eventStore.eventsMatchingPredicate(searchPredicate) as [EKEvent]
		
		if events.count == 0 {
			print("No events could be found")
		} else {
			
			// Go through all the events and print them to the console
			for event in events{
				if(excludeAllDay && event.allDay){
					continue
				}
				
				print("Event title = \(event.title)")
				print("Event start date = \(event.startDate)")
				print("Event end date = \(event.endDate)")
				pieClock.addPiece(event.startDate, end: event.endDate)
				let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
				
				self.view.addSubview(label)
			}
		}
		
	}
	
	func layout(){
		pieClock.frame = CGRectMake((screenWidth - shorter)/2, (screenHeight - shorter)/2, shorter, shorter)
		print("layout changed")
		
		// 背景グラデーションの設定
		let topColor = UIColor.hexStr("#F7931E")
		let bottomColor = UIColor.hexStr("#ED1C24")
		
		let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
		let gradientLayer = CAGradientLayer()
		
		gradientLayer.colors = gradientColors
		gradientLayer.frame  = CGRectMake(0, 0, longer, longer)
		
		self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
	}
	
	func loadPie() {
		
		layout()
		pieClock.theme(nil)
		pieClock.addHourHand(NSDate())

		self.view.addSubview(pieClock)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		
	
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		
		// 端末の向きがかわったらNotificationを呼ばす設定.
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
		
	}

	func onOrientationChange(notification: NSNotification){
		
		layout()
		
		// 現在のデバイスの向きを取得.
		let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
		
		
		// 向きの判定.
		if UIDeviceOrientationIsLandscape(deviceOrientation) {
			//横向きの判定.
			//向きに従って位置を調整する.
			
		} else if UIDeviceOrientationIsPortrait(deviceOrientation){
			//縦向きの判定.
			//向きに従って位置を調整する.
		}

	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}

}

