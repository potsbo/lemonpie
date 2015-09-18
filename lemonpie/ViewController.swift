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
		
		let testDraw = Pie(frame: CGRectMake((screenWidth - shorter)/2, (screenHeight - shorter)/2, shorter, shorter))
		self.view.addSubview(testDraw)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

