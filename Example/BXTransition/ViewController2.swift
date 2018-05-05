//
//  ViewController2.swift
//  BXTransition
//
//  Created by Breno Pinto on 09/02/18.
//  Copyright © 2018 Breno Pinto. All rights reserved.
//

import UIKit
import BXTransition

class ViewController2: UIViewController {
  var transition: BXTransition!
  let interactor = Interactor()
  
  override func viewDidAppear(_ animated: Bool) {
    transitioningDelegate = self
    
    transition = BXTransition(viewController: self)
    transition.interactor = interactor
    transition.setDismiss(directionAccepted: .top)
  }
  
  @IBAction func pangGesture(_ sender: Any) {
    guard let gesture = sender as? UIGestureRecognizer else { return }
    transition.panGesture(view: view, gesture: gesture)
  }
}

extension ViewController2: UIViewControllerTransitioningDelegate {
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return transition
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}
