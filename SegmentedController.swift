//
//  SegmentedController.swift
//  Fretless
//
//  Created by Ricardo Nazario on 5/3/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedController: UIControl, ThumbDelegate {
    
    private var labels = [UILabel]()
    var thumbView = ThumbView()
    
    public var items: [String] = ["Item 1", "Item 2", "Item 3"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int! = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    public var currentValue: String!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        let borderColor = UIColor.init(red: 55/255, green: 84/255, blue: 84/255, alpha: 1.0)
        let fillColor = UIColor.init(red: 64/255, green: 92/255, blue: 94/255, alpha: 1.0)
        
        layer.cornerRadius = frame.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
        backgroundColor = fillColor
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            label.text = items[index - 1]
            label.textAlignment = .center
            label.textColor = UIColor(white: 1.0, alpha: 1.0)
            label.font = label.font.withSize(15)
            self.addSubview(label)
            labels.append(label)
        }
        
        thumbView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = CGFloat(selectFrame.width) / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = UIColor.init(red: 22/255, green: 52/255, blue: 50/255, alpha: 1.0)
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1 {
            
            let label = labels[index]
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
        }
        
        self.displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            
            if item.frame.contains(CGPoint(x: location.x, y: item.center.y)) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }

        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let location = touch?.location(in: self)
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            
            if item.frame.contains(CGPoint(x: (location?.x)!, y: item.center.y)) {
                calculatedIndex = index
            }
            
            if calculatedIndex != nil {
                selectedIndex = calculatedIndex!
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func startedTouchingThumbView(location: CGPoint) {
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            
            if item.frame.contains(CGPoint(x: location.x, y: item.center.y)) {
                calculatedIndex = index
            }
            
            if calculatedIndex != nil {
                selectedIndex = calculatedIndex!
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func isTouchingThumbView(location: CGPoint) {
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            
            if item.frame.contains(CGPoint(x: location.x, y: item.center.y)) {
                calculatedIndex = index
            }
            
            if calculatedIndex != nil {
                selectedIndex = calculatedIndex!
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func didEndTouchInThumbView(location: CGPoint) {
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            
            if item.frame.contains(CGPoint(x: location.x, y: item.center.y)) {
                calculatedIndex = index
            }
            
            if calculatedIndex != nil {
                selectedIndex = calculatedIndex!
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func moveIndicatorTo(touchX: CGFloat) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .allowAnimatedContent,
                       animations: {
                        self.thumbView.center.x = touchX
        },
                       completion: nil
        )
        
        
    }
    
    func displayNewSelectedIndex() {
        
        let label = labels[selectedIndex]
        self.currentValue = self.items[selectedIndex]
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .allowAnimatedContent,
                       animations: {
                        self.thumbView.frame = label.frame
        },
                       completion: nil)
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
