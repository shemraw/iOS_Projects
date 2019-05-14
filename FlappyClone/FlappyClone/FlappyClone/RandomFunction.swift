//
//  FandomFunction.swift
//  FlappyClone
//
//  Created by Shemon on 4/28/19.
//  Copyright © 2019 Shemon. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    static func random() -> CGFloat{  // return type cgfloat
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)  //arc4random creates a random number
    }                                                     // divide by 0xFFFFFFFF to get a 32-bit number
    
    static func random(min : CGFloat, max : CGFloat) -> CGFloat{ // min and max value random
        return CGFloat.random() * (max - min) + min // return a random value between max and min value
    }
    
    
}
