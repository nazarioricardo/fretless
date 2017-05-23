//
//  GradientView.swift
//  Fretless
//
//  Created by Ricardo Nazario on 4/28/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        guard let theLayer = self.layer as? CAGradientLayer else {
            return;
        }
        
        let topColor = UIColor.init(red: 115/255, green: 227/255, blue: 245/255, alpha: 0.9)
        let bottomColor = UIColor.init(red: 213/255, green: 249/255, blue: 255/255, alpha: 0.9)
        
        theLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        theLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        theLayer.endPoint = CGPoint(x: 0.5, y: 1)
        theLayer.frame = self.bounds
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
