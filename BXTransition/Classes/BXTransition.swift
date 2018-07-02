//
//  BXTransition.swift
//  BXTransition
//
//  Created by Breno Pinto on 22/03/18.
//  Copyright © 2018 Breno Pinto. All rights reserved.
//

import UIKit

public class Interactor: UIPercentDrivenInteractiveTransition {
  public var hasStarted = false
  public var shouldFinish = false
}

public enum Direction {
  case left   // 315 - 360 || 0 - 45
  case top    // 45  - 135
  case right  // 135 - 225
  case bottom // 225 - 315
}

public class BXTransition: NSObject {
  
  private var initialPosition: CGPoint?
  private var currentPosition: CGPoint?
  private var isTranslationActive = false
  
  private var vcLeft: UIViewController?
  private var vcRight: UIViewController?
  private var vcTop: UIViewController?
  private var vcBottom: UIViewController?
  
  fileprivate var duration: TimeInterval = 0.3
  fileprivate var angleDirection: Direction?
  
  private var showDirectionsAccepted = [Direction]()
  private var dismissDirectionAccepted: Direction?
  
  private let percentThreshold: CGFloat = 0.3
  
  private let viewController: UIViewController
  
  public var interactor: Interactor?
  
  public init(viewController: UIViewController) {
    self.viewController = viewController
    super.init()
  }
 
  func getDirection(angle: CGFloat) -> Direction {
    if (angle >= 315 && angle <= 360 || angle >= 0 && angle < 45) {
      return Direction.left
    }
    if (angle >= 45 && angle < 135) {
      return Direction.top
    }
    if (angle >= 135 && angle < 225) {
      return Direction.right
    }
    if (angle >= 225 && angle < 315) {
      return Direction.bottom
    }
    return Direction.left
  }
  
  public func set(angleDirection: Direction) {
    self.angleDirection = angleDirection
  }
  
  func isDirectionAccepted(direction: Direction, directionsAccepted: [Direction]) -> Bool {
    return directionsAccepted.contains(direction)
  }
  
  public func panGesture(view: UIView, gesture: UIGestureRecognizer) {
    let translation = gesture.location(in: view)
    
    switch gesture.state {
    case .began:
      initialPosition = translation
      interactor?.shouldFinish = false
    case .changed:
      if (angleDirection == nil) {
        if (initialPosition != nil) {
          let angle = pointPairToBearingDegrees(initialPosition!, translation)
          angleDirection = getDirection(angle: angle)
          if (isDirectionAccepted(direction: angleDirection!, directionsAccepted: showDirectionsAccepted)) {
            currentPosition = translation
          }
        }
      } else {
        if let viewController = getShowViewController(forDirection: angleDirection!) {
          if (interactor?.hasStarted == false) {
            interactor?.hasStarted = true
            self.viewController.present(viewController, animated: true, completion: nil)
          }
          if let initialPosition = initialPosition {
            if (angleDirection == .left && translation.x > 0) {
              return
            }
            if (angleDirection == .right && translation.x < 0) {
              return
            }
            if (angleDirection == .top && translation.y > 0) {
              return
            }
            if (angleDirection == .bottom && translation.y < 0) {
              return
            }
            
            var distanceTranslation: CGFloat!
            if (angleDirection == .left) {
              distanceTranslation = view.frame.width + (translation.x - initialPosition.x)
            }
            if (angleDirection == .right) {
              distanceTranslation = view.frame.width + (initialPosition.x - translation.x)
            }
            if (angleDirection == .top) {
              distanceTranslation = view.frame.height + (translation.y - initialPosition.y)
            }
            if (angleDirection == .bottom) {
              distanceTranslation = view.frame.height + (initialPosition.y - translation.y)
            }
            
            var progress: CGFloat!
            if (angleDirection == .left || angleDirection == .right) {
              progress = distanceTranslation / view.frame.width
            }
            if (angleDirection == .top || angleDirection == .bottom) {
              progress = distanceTranslation / view.frame.height
            }
            
            interactor?.shouldFinish = progress > percentThreshold
            interactor?.update(progress)
          }
        }
        
        // Dismiss
        if (angleDirection == dismissDirectionAccepted) {
          if (interactor?.hasStarted == false) {
            interactor?.hasStarted = true
            interactor?.shouldFinish = false
            self.viewController.dismiss(animated: true, completion: nil)
          } else {
            if let initialPosition = initialPosition {
              var distanceTranslation: CGFloat!
              if (angleDirection == .right) {
                distanceTranslation = view.frame.width + (initialPosition.x - translation.x)
              }
              if (angleDirection == .left) {
                distanceTranslation = view.frame.width + (translation.x - initialPosition.x)
              }
              if (angleDirection == .top) {
                distanceTranslation = view.frame.height + (translation.y - initialPosition.y)
              }
              if (angleDirection == .bottom) {
                distanceTranslation = view.frame.height + (initialPosition.y - translation.y)
              }
              
              var progress: CGFloat!
              if (angleDirection == .left || angleDirection == .right) {
                progress = distanceTranslation / view.frame.width
              }
              if (angleDirection == .top || angleDirection == .bottom) {
                progress = distanceTranslation / view.frame.height
              }
              
              interactor?.shouldFinish = progress > percentThreshold
              interactor?.update(progress)
            }
          }
        }
      }
    case .cancelled:
      clearTransition()
      interactor?.hasStarted = false
      interactor?.cancel()
    case .ended:
      clearTransition()
      if let interactor = interactor {
        interactor.hasStarted = false
        interactor.shouldFinish ? interactor.finish() : interactor.cancel()
      }
    default:
      break
    }
  }
  
  private func getShowViewController(forDirection direction: Direction) -> UIViewController? {
    if (direction == .left) {
      return vcLeft
    }
    if (direction == .right) {
      return vcRight
    }
    if (direction == .top) {
      return vcTop
    }
    if (direction == .bottom) {
      return vcBottom
    }
    return nil
  }
  
  public func set(viewController: UIViewController, forDirection direction: Direction) {
    if (direction == .left) {
      vcLeft = viewController
    }
    if (direction == .right) {
      vcRight = viewController
    }
    if (direction == .top) {
      vcTop = viewController
    }
    if (direction == .bottom) {
      vcBottom = viewController
    }
    if (!showDirectionsAccepted.contains(direction)) {
      showDirectionsAccepted.append(direction)
    }
  }
  
  public func setDismiss(directionAccepted: Direction) {
    self.dismissDirectionAccepted = directionAccepted
  }
  
  func clearTransition() {
    isTranslationActive = false
    initialPosition = nil
    angleDirection = nil
  }
  
  func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
  }
  
  func pointPairToBearingDegrees(_ startingPoint: CGPoint, _ endingPoint: CGPoint) -> CGFloat {
    let originPoint = CGPoint(x: endingPoint.x - startingPoint.x, y: endingPoint.y - startingPoint.y)
    let bearingRadians = atan2(originPoint.y, originPoint.x)
    var bearingDegrees = bearingRadians * (180.0 / CGFloat.pi)
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees))
    return bearingDegrees
  }
}

extension BXTransition: UIViewControllerAnimatedTransitioning {
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let angleDirection = self.angleDirection else { return }
    let containerView = transitionContext.containerView
    
    let toView = transitionContext.view(forKey: .to)!
    
    containerView.addSubview(toView)
    
    // Coming from left
    if (angleDirection == .left) {
      toView.frame = CGRect(x: containerView.frame.origin.x - containerView.frame.width,
                            y: 0,
                            width: containerView.frame.width,
                            height: containerView.frame.height)
    }
      
    if (angleDirection == .right) {
      toView.frame = CGRect(x: containerView.frame.origin.x + containerView.frame.width,
                            y: 0,
                            width: containerView.frame.width,
                            height: containerView.frame.height)
    }
    
    if (angleDirection == .top) {
      toView.frame = CGRect(x: 0,
                            y: containerView.frame.origin.y - containerView.frame.height,
                            width: containerView.frame.width,
                            height: containerView.frame.height)
    }
    
    if (angleDirection == .bottom) {
      toView.frame = CGRect(x: 0,
                            y: containerView.frame.origin.y + containerView.frame.height,
                            width: containerView.frame.width,
                            height: containerView.frame.height)
    }
    
    let initialCenter = containerView.center
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
      if (angleDirection == .left) {
        containerView.center = CGPoint(x: initialCenter.x + containerView.frame.width,
                                       y: initialCenter.y)
      }
      
      if (angleDirection == .right) {
        containerView.center = CGPoint(x: initialCenter.x - containerView.frame.width,
                                       y: initialCenter.y)
      }
      
      if (angleDirection == .top) {
        containerView.center = CGPoint(x: initialCenter.x,
                                       y: initialCenter.y + containerView.frame.height)
      }
      
      if (angleDirection == .bottom) {
        containerView.center = CGPoint(x: initialCenter.x,
                                       y: initialCenter.y - containerView.frame.height)
      }
    }) { _ in
      toView.frame = CGRect(origin: CGPoint.zero, size: toView.frame.size)
      containerView.frame = CGRect(origin: CGPoint.zero, size: containerView.frame.size)
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      
      if (transitionContext.transitionWasCancelled) {
        toView.removeFromSuperview()
      }
    }
  }
}

