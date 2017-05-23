//
//  KeyBoardView.swift
//  Fretless
//
//  Created by Ricardo Nazario on 4/27/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit

protocol KeyBoardDelegate {
    func xAxis(keyFreq: Float, x: Float)
    func yAxis(y: Float)
    func stoppedPlaying()
}

class KeyBoardView: UIControl {
    
    var delegate: KeyBoardDelegate?
    
    var frequency: Float = Float()
    
    var touchViewWidth: CGFloat!
    var touchViewIndicator = TouchIndicatorView()
    
    var attackTime: Double!
    var releaseTime: Double!
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        if (touchViewIndicator.superview != nil) {
            touchViewIndicator.removeFromSuperview()
        }
        
        let xTouch = touch.location(in: self).x
        let yTouch = touch.location(in: self).y

        delegate?.xAxis(keyFreq: frequency, x: Float((xTouch - touchViewWidth/2)/touchViewWidth))
        delegate?.yAxis(y: Float(touch.location(in: self).y))
        
        createTouchIndicator(x: xTouch, y: yTouch)
        
        self.touchViewIndicator.alpha = yTouch/self.bounds.maxY
        
        UIView.animate(withDuration: attackTime,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.touchViewIndicator.alpha = yTouch/self.bounds.maxY
        },
                       completion: nil)
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let xTouch = touch.location(in: self).x
        let yTouch = touch.location(in: self).y
        delegate?.xAxis(keyFreq: frequency, x: Float((xTouch - touchViewWidth/2)/touchViewWidth))
        delegate?.yAxis(y: Float(touch.location(in: self).y))
        
        let touchViewCenter = CGPoint(x: touch.location(in: self).x, y: self.bounds.midY)
    
        self.touchViewIndicator.center.x = touchViewCenter.x
        self.touchViewIndicator.frame.size.height = yTouch + 200
        
        UIView.animate(withDuration: 0,
                       delay: 0,
                       usingSpringWithDamping: 0,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        
                        self.touchViewIndicator.center.x = touchViewCenter.x
                        self.touchViewIndicator.frame.size.height = yTouch + 200
                        self.touchViewIndicator.alpha = yTouch/self.bounds.maxY
        },
                       completion: nil)

        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.stoppedPlaying()
        
        UIView.animate(withDuration: releaseTime * 5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.touchViewIndicator.alpha = 0
        },
                       completion: nil)
        
        
    }
    
    func createTouchIndicator(x: CGFloat, y: CGFloat) {
        
        touchViewIndicator = TouchIndicatorView.init(frame: CGRect(x: x - (touchViewWidth / 2), y: self.bounds.minY - 200, width: touchViewWidth, height: y + 200))
        
        touchViewIndicator.backgroundColor = UIColor(red: 0/255, green: 220/255, blue: 255/255, alpha: 1)
        touchViewIndicator.alpha = 0
        
        self.addSubview(touchViewIndicator)
    }
    
    func setUpView() {
//        createTouchIndicator(x: 0, y: 0)
        self.backgroundColor = UIColor.clear
        
        addGradient()
        
    }
    
    func addGradient() {
        
        let gradient = CAGradientLayer()
        let leftColor = UIColor.white.withAlphaComponent(0.3)
        let rightColor = UIColor.white.withAlphaComponent(0.0)
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        
        self.backgroundColor = leftColor
        
        self.layer.addSublayer(gradient)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
