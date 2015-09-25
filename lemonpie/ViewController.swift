//
//  ViewController.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 19/09/2015.
//  Copyright © 2015 mikan-labs. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, PieDelegate, TimeManageProtocol {
	
	var timer: NSTimer!
	let eventStore = EKEventStore()
	
	// views
	let pieClock = Pie(frame: CGRectMake(0,0,0,0))
	var timeDifferenceView = TimeDifferenceView(frame: CGRectMake(0,0,0,0))
	var digitalClockView = DigitalClockView(frame: CGRectMake(0,0,0,0))
	
	
	// window size
	var shorter: CGFloat {
		return min(screenWidth, screenHeight)
	}
	var longer: CGFloat {
		return max(screenWidth, screenHeight)
	}
	var screenWidth: CGFloat {
		return self.view.bounds.width
	}
	var screenHeight: CGFloat {
		return self.view.bounds.height
	}
	
	// time management
	var clock = CushoningTime()
	
	func clockTimeChangedTo(newDate: NSDate){
		pieClock.startDate = clock.time
		digitalClockView.clockTime = clock.time
	}
	
	var timeDiff: NSTimeInterval {
		if !isTimeTraveling {
			return 0
		}
		return clock.time.timeIntervalSinceNow
	}
	var isTimeTraveling = false
	
	// settings
	let excludeAllDay = true
	
	// view loading
	override func viewWillAppear(animated: Bool) {
		checkCalendarAuthorizationStatus()
	}
	override func viewDidAppear(animated: Bool) {
		
		// 端末の向きがかわったらNotificationを呼ばす設定.
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update:", userInfo: nil, repeats: true)
		
		// TODO: this gesture to be changed to double tap
		let test = UILongPressGestureRecognizer(target: self, action: "doubleTap:")
		self.view.addGestureRecognizer(test)
		
		// double tap to back to the current TODO: this doesn't work, maybe because of XMCircleGestureRecognizer
		let doubleTapGesture = UITapGestureRecognizer(target: self, action:"doubleTap:")
		doubleTapGesture.numberOfTapsRequired = 2
		self.view.addGestureRecognizer(doubleTapGesture)
				
	}
	
	func update(timer : NSTimer){
		if !isTimeTraveling {
			clock.setNewTime(NSDate())
		} else {
			
		}
	}
	
	
	// Calendar
	func checkCalendarAuthorizationStatus() {
		let status = EKEventStore.authorizationStatusForEntityType(.Event)
		
		switch (status) {
		case EKAuthorizationStatus.NotDetermined:
			// This happens on first-run
			requestAccessToCalendar()
		case EKAuthorizationStatus.Authorized:
			// Things are in line with being able to show the calendars in the table view
			loadApp()
			readEvents()
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
		if granted == true {
			// Ensure that UI refreshes happen back on the main thread!
			dispatch_async(dispatch_get_main_queue(), {
				self.loadApp()
				self.readEvents()
			})
		} else {
			// Ensure that UI refreshes happen back on the main thread!
			dispatch_async(dispatch_get_main_queue(), {
				//self.needPermissionView.fadeIn()
			})
		}
	}
	
	func readEvents(){
		
		/* Instantiate the event store */
		let eventStore = EKEventStore()
		

		let startDate = pieClock.startDate
		let endDate = pieClock.endDate
		
		/* Create the predicate that we can later pass to the
		event store in order to fetch the events */
		let searchPredicate = eventStore.predicateForEventsWithStartDate(
			startDate,
			endDate: endDate.dateByAddingTimeInterval(60*60*24*7), calendars: nil)
		
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
				pieClock.addPiece(event)
			}
		}
		
	}
	
	
	// view controll
	func layout(){
		// 現在のデバイスの向きを取得.
		let isPortrait = (longer == screenHeight)
		
		if isPortrait {
			timeDifferenceView.frame = CGRectMake((2*screenWidth - shorter) / 2, 0, screenWidth / 2, (screenHeight - shorter)/2)
			digitalClockView.frame = CGRectMake(0, 0, screenWidth/2, (screenHeight - shorter))
		} else {
			timeDifferenceView.frame = CGRectMake((screenWidth - shorter )/2 + shorter, 0, (screenWidth - shorter)/2, screenHeight/2)
			digitalClockView.frame = CGRectMake(0, 0, (screenWidth - shorter)/2, screenHeight/2)
		}
		
		
		pieClock.frame = CGRectMake((screenWidth - shorter)/2, (screenHeight - shorter)/2, shorter, shorter)
		
		// 背景グラデーションの設定
		let topColor = UIColor.hexStr("#F7931E")
		let bottomColor = UIColor.hexStr("#ED1C24")
		let gradientColors = [topColor.CGColor, bottomColor.CGColor]
		let gradientLayer = CAGradientLayer()
		
		gradientLayer.colors = gradientColors
		gradientLayer.frame  = CGRectMake(0, 0, longer, longer)
		
		self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
	}

	
	// time travel
	func startTimeTravel() {
		if !self.isTimeTraveling {
			print("Start time traveling")
			self.isTimeTraveling = true
			timeDifferenceView.startTimeTravel()
		}
	}
	
	func endTimeTravel() {
		if self.isTimeTraveling {
			print("end of time travel")
			self.isTimeTraveling = false
			timeDifferenceView.endTimeTravel()
			clock.setNewTime(NSDate())
			timeDifferenceDidChange()
		}
	}
	
	func timeTravelByInterval(interval: NSTimeInterval){
		if !isTimeTraveling {
			self.startTimeTravel()
		}
		clock.dateByAddingTimeInterval(interval, force: true)
		timeDifferenceDidChange()
	}
	
	func timeDifferenceDidChange() {
		timeDifferenceView.timeDifference = self.timeDiff
	}
	
	
	func loadApp() {
		
		layout()
		timeDifferenceView.hidden = true
		self.view.addSubview(timeDifferenceView)
		
		self.view.addSubview(digitalClockView)
		digitalClockView.fadeIn(.Slow)
		
		clock.delegate = self
		pieClock.delegate = self
		pieClock.applyTheme()
		pieClock.addHourHand(NSDate())
		pieClock.fadeIn(.Slow)
		self.view.addSubview(pieClock)
	}
	
	
	
	// gesture actions
	func doubleTap(gesture: UITapGestureRecognizer) -> Void {
		print("double tapped")
		self.endTimeTravel()
	}
	
	

	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	

	func onOrientationChange(notification: NSNotification){
		
		layout()
		
	}
	
	
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}

}

