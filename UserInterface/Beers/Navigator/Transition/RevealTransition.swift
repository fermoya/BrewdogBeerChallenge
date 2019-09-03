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
    
    private var sourceImageLayer: CALayer
    private var fromViewSnapshot: UIView!
    private var fromViewSecondSnapshot: UIView!
    
    init(view: UIImageView) {
        sourceImageLayer = CAShapeLayer()
        sourceImageLayer.frame = view.frame
        sourceImageLayer.contents = view.image?.cgImage
        
        // In case the image has transparent pixels
        view.isHidden = true
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
        
        // We take this snapshot to cover the next view. This one will contain the source image view as it is taken before the screen updates
        fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false)!
        fromViewSnapshot.frame = fromView.frame
        
        // We take a second snapshot after the screen updates so that the source image view is hidden. This snapshot will cover the previous one. This way we prevent a glitch on the transition
        fromViewSecondSnapshot = fromView.snapshotView(afterScreenUpdates: true)!
        fromViewSecondSnapshot.frame = fromViewSnapshot.frame
        
        fromViewSecondSnapshot.layer.addSublayer(sourceImageLayer)
        
        toView.addSubview(fromViewSnapshot)
        toView.addSubview(fromViewSecondSnapshot)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 1
        scaleAnimation.delegate = self
        scaleAnimation.toValue = 15
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        scaleAnimation.isRemovedOnCompletion = true
        sourceImageLayer.add(scaleAnimation, forKey: nil)
        
        let fadeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        fadeAnimation.duration = duration
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.fillMode = .both
        fadeAnimation.values = [1, 0]
        fadeAnimation.keyTimes = [0.5, 1]
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        sourceImageLayer.add(fadeAnimation, forKey: nil)
        fromViewSnapshot.layer.add(fadeAnimation, forKey: nil)
        fromViewSecondSnapshot.layer.add(fadeAnimation, forKey: nil)
    }
    
}

extension RevealTransition: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let context = self.transitionContext else { return }
        
        let toView = context.view(forKey: .to)!
        toView.layer.mask = nil
        
        context.completeTransition(!context.transitionWasCancelled)
        sourceImageLayer.removeFromSuperlayer()
        fromViewSnapshot.removeFromSuperview()
        fromViewSecondSnapshot.removeFromSuperview()
        toView.layer.removeAllAnimations()
        
        self.transitionContext = nil
    }
    
}
