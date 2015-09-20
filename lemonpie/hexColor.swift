//
//  hexColor.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 21/09/2015.
//  http://qiita.com/reoy/items/a4223cebf312beeed6e9
//

import Foundation
import UIKit

extension UIColor {
	class func hexStr (var hexStr : NSString, alpha : CGFloat = 1.0) -> UIColor {
		hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
		let scanner = NSScanner(string: hexStr as String)
		var color: UInt32 = 0
		if scanner.scanHexInt(&color) {
			let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
			let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
			let b = CGFloat(color & 0x0000FF) / 255.0
			return UIColor(red:r,green:g,blue:b,alpha:alpha)
		} else {
			print("invalid hex string")
			return UIColor.whiteColor();
		}
	}
}
