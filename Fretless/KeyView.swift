//
//  KeyControl.swift
//  Fretless
//
//  Created by Ricardo Nazario on 2/22/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit

class KeyView: UIView {
    
    var keyColor: UIColor!
    var keyIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
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
