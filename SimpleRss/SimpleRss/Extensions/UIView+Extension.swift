//
//  UIView+Extension.swift
//  SimpleRss
//
//  Created by Voldem on 12/26/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

extension UIView {
    
    func zoomingBoundAnimate() {
        transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5 ) { [weak self] in
            self?.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }
        
        animator.startAnimation()
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.frame = bounds
        blurEffectView.layer.zPosition = -1

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func removeBlurEffect() {
        let blurredEffectViews = subviews.filter { $0 is UIVisualEffectView }
        blurredEffectViews.forEach { blurView in
            blurView.removeFromSuperview()
        }
    }
}
