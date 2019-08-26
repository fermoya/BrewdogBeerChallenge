//
//  RevealAndSpinTransition.swift
//  UserInterface
//
//  Created by Fernando Moya de Rivas on 25/08/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class RevealTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitionContext: UIViewControllerContextTransitioning?
    var duration: TimeInterval = 1
    
    private var snapshot: CALayer
    private var fromViewSnapshot: UIView!
    
    init(view: UIImageView) {
        self.snapshot = view.layer
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView: UIView! = toVC.view
        let fromView = transitionContext.view(forKey: .from)!
        
        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.bringSubviewToFront(toView)
        self.transitionContext = transitionContext
        
//        toView.layer.mask = snapshot
        fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false)!
        fromViewSnapshot.frame = fromView.frame
        toView.addSubview(fromViewSnapshot)
        toView.layer.addSublayer(snapshot)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 1
        scaleAnimation.delegate = self
        scaleAnimation.toValue = 15
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        scaleAnimation.isRemovedOnCompletion = true
        snapshot.add(scaleAnimation, forKey: nil)
        
        let fadeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        fadeAnimation.duration = duration
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.fillMode = .both
        fadeAnimation.values = [1, 0]
        fadeAnimation.keyTimes = [0.5, 1]
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        snapshot.add(fadeAnimation, forKey: nil)
        fromViewSnapshot.layer.add(fadeAnimation, forKey: nil)
    }
    
}

extension RevealTransition: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let context = self.transitionContext else { return }
        
        let toView = context.view(forKey: .to)!
        toView.layer.mask = nil
        
        context.completeTransition(!context.transitionWasCancelled)
        snapshot.removeFromSuperlayer()
        fromViewSnapshot.removeFromSuperview()
        toView.layer.removeAllAnimations()
        
        self.transitionContext = nil
    }
    
}
