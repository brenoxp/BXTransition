//
//  ViewController4.swift
//  BXTransition
//
//  Created by Breno Pinto on 09/02/18.
//  Copyright © 2018 Breno Pinto. All rights reserved.
//

import UIKit
import BXTransition

class ViewController4: UIViewController {
  var transition: BXTransition!
  let interactor = Interactor()
  
  override func viewDidAppear(_ animated: Bool) {
    transitioningDelegate = self
    
    transition = BXTransition(viewController: self)
    transition.interactor = interactor
    transition.setDismiss(directionAccepted: .bottom)
  }
  
  @IBAction func pangGesture(_ sender: Any) {
    guard let gesture = sender as? UIGestureRecognizer else { return }
    transition.panGesture(view: view, gesture: gesture)
  }
}

extension ViewController4: UIViewControllerTransitioningDelegate {
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return transition
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}
