//
//  ImageView+RotateAnimation.swift
//  kyc
//
//  Created by Trieu Dinh Quy on 8/26/19.
//  Copyright © 2019 Trieu Dinh Quy. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIImageView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIImageView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIImageView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIImageView.kRotationAnimationKey)
        }
    }
}
