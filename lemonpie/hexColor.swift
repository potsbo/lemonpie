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
    class func hexStr(hexStr : String, alpha : CGFloat = 1.0) -> UIColor {
        var hexStr = hexStr
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as String
        let scanner = Scanner(string: hexStr as String)
		var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
			let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
			let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
			let b = CGFloat(color & 0x0000FF) / 255.0
			return UIColor(red:r,green:g,blue:b,alpha:alpha)
		} else {
			print("invalid hex string")
      return UIColor.white
		}
	 }
}
