//
//  RotatingView.swift
//  Recur
//
//  Created by Leslie Ho on 7/2/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class RotatingView: UIView {
    func startRotating() {
        let animationKey = "rotation"
        if self.layer.animation(forKey: animationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 200
            animate.repeatCount = .infinity
            animate.fromValue = 0
            animate.toValue = .pi * 2.0
            self.layer.add(animate, forKey: animationKey)
        }
    }

    func stopRotating() {
        UIView.animate(withDuration: 2.0, animations: {
            self.alpha = 0.0
        }, completion: {
            _ in self.layer.removeAllAnimations()
        })
    }
}
