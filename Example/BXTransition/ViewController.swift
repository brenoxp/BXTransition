//
//  ViewController.swift
//  BXTransition
//
//  Created by Breno Pinto on 09/02/18.
//  Copyright © 2018 Breno Pinto. All rights reserved.
//

import UIKit
import BXTransition

class ViewController: UIViewController {
  
  var transition: BXTransition!
  let interactor = Interactor()

  override func viewDidLoad() {
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    transition = BXTransition(viewController: self)
    transition.interactor = interactor
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let viewController1 = storyboard.instantiateViewController(withIdentifier: "ViewController1")
    viewController1.transitioningDelegate = self
    transition.set(viewController: viewController1, forDirection: .right)
    
    let viewController2 = storyboard.instantiateViewController(withIdentifier: "ViewController2")
    viewController2.transitioningDelegate = self
    transition.set(viewController: viewController2, forDirection: .bottom)
    
    let viewController3 = storyboard.instantiateViewController(withIdentifier: "ViewController3")
    viewController3.transitioningDelegate = self
    transition.set(viewController: viewController3, forDirection: .left)
    
    let viewController4 = storyboard.instantiateViewController(withIdentifier: "ViewController4")
    viewController4.transitioningDelegate = self
    transition.set(viewController: viewController4, forDirection: .top)
  }
  
  @IBAction func pangGesture(_ sender: Any) {
    guard let gesture = sender as? UIGestureRecognizer else { return }
    transition.panGesture(view: view, gesture: gesture)
  }
}

extension ViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return transition
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}
