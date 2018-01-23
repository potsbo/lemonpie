//
//  fade.swift
//  lemonpie
//
//  Created by Shimpei Otsubo on 22/09/2015.
//  http://qiita.com/mono0926/items/c53b2e46e51a0b0bbf06
//

import Foundation
import UIKit

enum FadeType: TimeInterval {
	case
	Normal = 0.2,
	Slow = 1.0
}

extension UIView {
	func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeIn(type: type, completed: completed)
	}
	
	/** For typical purpose, use "public func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
		alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration,
			animations: {
				self.alpha = 1
			}) { finished in
				completed?()
		}
	}
	func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeOut(type: type, completed: completed)
	}
	/** For typical purpose, use "public func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration
			, animations: {
				self.alpha = 0
			}) { [weak self] finished in
                self?.isHidden = true
				self?.alpha = 1
				completed?()
		}
	}
}
