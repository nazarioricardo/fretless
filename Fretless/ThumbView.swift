//
//  ThumbView.swift
//  Fretless
//
//  Created by Ricardo Nazario on 5/22/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit

protocol ThumbDelegate {
    func startedTouchingThumbView(location: CGPoint)
    func isTouchingThumbView(location: CGPoint)
    func didEndTouchInThumbView(location: CGPoint)
}

class ThumbView: UIControl {
    
    var delegate: ThumbDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        self.center.x = touch.location(in: self).x
        delegate?.startedTouchingThumbView(location: (touch.location(in: superview)))
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        delegate?.isTouchingThumbView(location: (touch.location(in: superview)))
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // Finished!
        delegate?.didEndTouchInThumbView(location: (touch?.location(in: superview))!)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
