//
//  FadeTransition.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/10/23.
//

import UIKit
import SwiftUICoordinator

class FadeTransition: NSObject//, Transition
{
//    func isEligible(from fromRoute: NavigationRoute, to toRoute: NavigationRoute, operation: NavigationOperation) -> Bool 
//    {
//        return (fromRoute as? CustomShapesRoute == .customShapes && toRoute as? CustomShapesRoute == .star)
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval 
//    {
//        return 0.3
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) 
//    {
//        guard let toView = transitionContext.view(forKey: .to) 
//        else
//        {
//            transitionContext.completeTransition(false)
//            return
//        }
//        
//        let containerView = transitionContext.containerView
//        toView.alpha = 0.0
//        
//        containerView.addSubview(toView)
//        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { toView.alpha = 1.0})
//        { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
}
