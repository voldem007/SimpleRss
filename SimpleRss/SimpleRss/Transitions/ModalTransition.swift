//
//  ModalTransition.swift
//  SimpleRss
//
//  Created by Voldem on 11/8/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import UIKit

final class ModalTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    let context: Context
    
    init(height: CGFloat = 340) {
        context = Context(height: height)
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Present(context: context)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Dismiss(context: context)
    }
}

extension ModalTransition {
    
    final class Context: NSObject, UIGestureRecognizerDelegate {

        private var keyboardOffset: CGFloat?
        
        var height: CGFloat
        let duration: TimeInterval = 0.4
        let hIndent: CGFloat = 30
        let dampingRatio: CGFloat = 0.8
        weak var containerView: UIView?
        weak var presentedController: UIViewController?

        init(height: CGFloat) {
            self.height = height
            super.init()
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        @objc
        private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                guard let containerView = containerView,
                    let presentedController = presentedController else {
                    return
                }
                
                let keyboardHeight = keyboardSize.height
                let availableTopHeight = containerView.frame.height - keyboardHeight
                let heightOfPopUp = presentedController.view.frame.origin.y + presentedController.view.frame.height
                keyboardOffset = heightOfPopUp - availableTopHeight
                if let keyboardOffset = keyboardOffset,
                    keyboardOffset > 0 {
                    presentedController.view.frame.origin.y = presentedController.view.frame.origin.y - keyboardOffset
                }
            }
        }
        
        @objc
        private func keyboardWillHide(notification: NSNotification) {
            guard let presentedController = presentedController,
                let keyboardOffset = keyboardOffset,
                keyboardOffset > 0 else { return }
            
            presentedController.view.frame.origin.y = presentedController.view.frame.origin.y + keyboardOffset
        }

        func getWidth(_ screenWidth: CGFloat) -> CGFloat {
            return screenWidth - 2 * hIndent
        }

        func getTopIndent(_ screenHeight: CGFloat) -> CGFloat {
            return (screenHeight - height) / 2 - 40
        }

        func getFinalRect(in bounds: CGSize) -> CGRect {
            return CGRect(x: hIndent, y: getTopIndent(bounds.height), width: getWidth(bounds.width), height: height)
        }

        func getStartRect(in bounds: CGSize) -> CGRect {
            return CGRect(x: hIndent, y: bounds.height, width: getWidth(bounds.width), height: height)
        }

        func setupGestureRecognizer(in containerView: UIView, presentedController: UIViewController) {
            self.containerView = containerView
            self.presentedController = presentedController

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
            tapGesture.delegate = self
            containerView.addGestureRecognizer(tapGesture)
        }

        @objc
        func close() {
            presentedController?.dismiss(animated: true, completion: nil)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            return touch.view == containerView
        }
    }
}

extension ModalTransition {

    final class Present: NSObject, UIViewControllerAnimatedTransitioning {

        let context: Context

        init(context: Context) {
            self.context = context
        }

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return context.duration
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let view = transitionContext.view(forKey: .to) else { return }

            view.clipsToBounds = true

            if let presentedController = transitionContext.viewController(forKey: .to) {
                context.setupGestureRecognizer(in: transitionContext.containerView, presentedController: presentedController)
            }

            let finalRect = context.getFinalRect(in: transitionContext.containerView.bounds.size)
            view.frame = context.getStartRect(in: transitionContext.containerView.bounds.size)

            transitionContext.containerView.addSubview(view)

            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: context.dampingRatio)

            animator.addAnimations { [weak transitionContext, weak view] in
                view?.frame = finalRect
                transitionContext?.containerView.addBlurEffect()
            }

            animator.addCompletion { position in
                transitionContext.completeTransition(position == .end)
            }

            animator.startAnimation()
        }
    }
}

extension ModalTransition {

    final class Dismiss: NSObject, UIViewControllerAnimatedTransitioning {

        let context: Context

        init(context: Context) {
            self.context = context
        }

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return context.duration
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let view = transitionContext.view(forKey: .from) else { return }
            let dismissRect = context.getStartRect(in: transitionContext.containerView.bounds.size)
            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: context.dampingRatio)

            animator.addAnimations { [weak view] in
                view?.frame = dismissRect
            }

            animator.addCompletion { position in
                transitionContext.completeTransition(position == .end)
            }

            animator.startAnimation()

            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                transitionContext.containerView.removeBlurEffect()
            }
        }
    }
}
