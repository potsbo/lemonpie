//
//  XMCircleGestureRecognizer.swift
//  XMCircleGestureRecognizer
//
//  Created by Michael Teeuw on 20-06-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private let π = CGFloat(Double.pi)

public extension CGFloat {
    var degrees:CGFloat {
        return self * 180 / π;
    }
    var radians:CGFloat {
        return self * π / 180;
    }
    var rad2deg:CGFloat {
        return self.degrees
    }
    var deg2rad:CGFloat {
        return self.radians
    }
}

public class XMCircleGestureRecognizer: UIGestureRecognizer {
	
    //MARK: Public Properties
    
    // midpoint for gesture recognizer
    public var midPoint = CGPoint(x: 0, y: 0)
    
    // minimal distance from midpoint
    public var innerRadius:CGFloat?
    
    // maximal distance to midpoint
    public var outerRadius:CGFloat?
    
    // relative rotation for current gesture (in radians)
    public var rotation:CGFloat? {
        if let currentPoint = self.currentPoint {
            if let previousPoint = self.previousPoint {
                var rotation = angleBetween(pointA: currentPoint, andPointB: previousPoint)
                
                if (rotation > π) {
                    rotation -= π*2
                } else if (rotation < -π) {
                    rotation += π*2
                }
                
                return rotation
            }
        }
        
        return nil
    }
    
    // absolute angle for current gesture (in radians)
    public var angle:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.angleForPoint(point: nowPoint)
        }
    
        return nil
    }
    
    // distance from midpoint
    public var distance:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
        }
    
        return nil
    }
    
    //MARK: Private Properties
    
    // internal usage for calculations. (Please give us Access Modifiers, Apple!)
    private var currentPoint:CGPoint?
    private var previousPoint:CGPoint?
    
    //MARK: Public Methods
    
    // designated initializer
    public init(midPoint:CGPoint, innerRadius:CGFloat?, outerRadius:CGFloat?, target:AnyObject, action:Selector) {
        super.init(target: target, action: action)
        
        self.midPoint = midPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        
    }
   
    // convinience initializer if innerRadius and OuterRadius are not necessary
    public convenience init(midPoint:CGPoint, target:AnyObject, action:Selector) {
        self.init(midPoint:midPoint, innerRadius:nil, outerRadius:nil, target:target, action:action)
    }
    
    
    //MARK: Private Methods
    
    private func distanceBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }
    
    private func angleForPoint(point:CGPoint) -> CGFloat {
        var angle = -atan2(point.x - midPoint.x, point.y - midPoint.y) + π/2

        if (angle < 0) {
            angle += π*2;
        }
        
        return angle
    }

    private func angleBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        return angleForPoint(point: pointA) - angleForPoint(point: pointB)
    }
    
    //MARK: Subclassed Methods

    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

		if let touch = touches.first {
            var newState:UIGestureRecognizerState = .possible
            currentPoint = touch.location(in: self.view)
			
 
            guard let dist = distance else {
                state = .failed
                return
            }
			if let innerRadius = self.innerRadius {
				if dist < innerRadius {
                    state = .failed
                    return
				}
			}
			
			if let outerRadius = self.outerRadius {
				if dist > outerRadius {
                    state = .failed
                    return
				}
			}
			if touches.count > 1 {
                state = .failed
                return
			}
		}
		
				
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		
        super.touchesMoved(touches, with: event)
        
        if state == .failed {
            return
        }
        
		if let touch = touches.first {
            currentPoint = touch.location(in: self.view)
            previousPoint = touch.previousLocation(in: self.view)
            state = .changed
		}
		
    }
	
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
		print("circle end")
        
        currentPoint = nil
        previousPoint = nil
    }
    
}
