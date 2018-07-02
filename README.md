# BXTransition

[![CI Status](https://img.shields.io/travis/brenoxp2008@hotmail.com/BXTransition.svg?style=flat)](https://travis-ci.org/brenoxp2008@hotmail.com/BXTransition)
[![Version](https://img.shields.io/cocoapods/v/BXTransition.svg?style=flat)](https://cocoapods.org/pods/BXTransition)
[![License](https://img.shields.io/cocoapods/l/BXTransition.svg?style=flat)](https://cocoapods.org/pods/BXTransition)
[![Platform](https://img.shields.io/cocoapods/p/BXTransition.svg?style=flat)](https://cocoapods.org/pods/BXTransition)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Gif](https://github.com/brenoxp/BXTransition/blob/master/Example/images/BXTransition.gif?raw=true)

## Usage - Present
```swift
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
```

## Usage - Dismiss
``` swift
import BXTransition

class ViewController1: UIViewController {
  var transition: BXTransition!
  let interactor = Interactor()
 
  override func viewDidAppear(_ animated: Bool) {
    transitioningDelegate = self

    transition = BXTransition(viewController: self)
    transition.interactor = interactor
    transition.setDismiss(directionAccepted: .left)
  }
  
  @IBAction func pangGesture(_ sender: Any) {
    guard let gesture = sender as? UIGestureRecognizer else { return }
    transition.panGesture(view: view, gesture: gesture)
  }
}

extension ViewController1: UIViewControllerTransitioningDelegate {
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return transition
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}
```


## Installation

BXTransition is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BXTransition'
```

## Author

Breno Xavier - brenoxp2008@gmail.com

## License

BXTransition is available under the MIT license. See the LICENSE file for more info.
