//
//  VideoListToPlayerTransitionAnimator.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/09/03.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit

class VideoListToPlayerTransitionAnimator: NSObject {
    
    // TODO: Fix animation when video is selected in landscape mode.
    
    // TODO: Fix animation in case of slow internet connection
    // Make it so that the dummyView will stay up there until the video is loaded.
    // Also, add some indicator from video loading.
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    fileprivate let duration: TimeInterval
    fileprivate let animationType: AnimationType
    
    init(duration: TimeInterval = 0.7, animationType: AnimationType) {
        self.duration = duration
        self.animationType = animationType
    }
    
}

extension VideoListToPlayerTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            animatePresentation(using: transitionContext)
        case .dismiss:
            animateDismissal(using: transitionContext)
        }
    }
    
    func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to),
            let nav = transitionContext.viewController(forKey: .from) as? UINavigationController,
            let vc = nav.topViewController as? VideoListViewController,
            let parameters = vc.getTransitionParameters(containingView: container) else {
                transitionContext.completeTransition(false)
                return
        }
        // animation preparation
        let dummyView = parameters.dummyView
        let xScaleFactor = toView.bounds.width/dummyView.bounds.width
        let yDiff = toView.center.y - dummyView.center.y
        toView.alpha = 0.0
        // hide original view
        let hideOriginalView = parameters.hideOriginalView
        // dummy background
        let bgView = UIView(frame: toView.bounds)
        bgView.backgroundColor = .black
        bgView.alpha = 0.0
        
        // setup subviews
        container.addSubview(hideOriginalView)
        container.addSubview(bgView)
        container.addSubview(toView)
        container.addSubview(dummyView)
        
        // animate
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            dummyView.layer.cornerRadius = 0.0
            dummyView.transform = CGAffineTransform(scaleX: xScaleFactor, y: xScaleFactor)
                .concatenating(CGAffineTransform(translationX: 0, y: yDiff))
            bgView.alpha = 1.0
        }) { (_) in
            toView.alpha = 1.0
            bgView.removeFromSuperview()
            dummyView.removeFromSuperview()
            hideOriginalView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("This is not implemented yet")
    }
}

extension VideoListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return VideoListToPlayerTransitionAnimator(animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    /// Get the dummy view to use in transition animation between VideoListViewController → VideoPlayerViewController
    /// - Parameter containingView: The view that will contain the dummyView. We adjust the dummy view's frame to the new coordinates.
    func getTransitionParameters(containingView: UIView) -> (dummyView: UIView, hideOriginalView: UIView)? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath) as? VideoCell,
            let dummyView = cell.thumbnailImageView.snapshotView(afterScreenUpdates: false) else {
                return nil
        }
        dummyView.frame = cell.thumbnailImageView.convert(cell.thumbnailImageView.frame, to: containingView)
        dummyView.layer.cornerRadius = cell.cardView.cornerRadius
        dummyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dummyView.clipsToBounds = true
        
        let hideOriginalView = UIView(frame: dummyView.frame)
        hideOriginalView.backgroundColor = cell.cardView.backgroundColor
        hideOriginalView.layer.cornerRadius = dummyView.layer.cornerRadius
        hideOriginalView.layer.maskedCorners = dummyView.layer.maskedCorners
        hideOriginalView.clipsToBounds = true
        return (dummyView, hideOriginalView)
    }
    
}
