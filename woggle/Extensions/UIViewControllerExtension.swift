//
//  UIViewControllerExtension.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//
// https://stackoverflow.com/questions/43150320/embed-uiviewcontroller-inside-a-uiview

import UIKit

extension UIViewController {
  
  // So, what happes here is that we state the controller is going to be added to this controller.
  // Then, set the view to be the same.
  // Add the bounds of the view are limited to the frame of the view controller
  // Add the controller
  // State the move is completed.
  func embed(_ viewController:UIViewController, inView view:UIView, origin o: CGPoint){
    viewController.willMove(toParent: self)
    viewController.view.frame.origin = o
    view.addSubview(viewController.view)
    self.addChild(viewController)
    viewController.didMove(toParent: self)
  }
  
  // As when I embed a UIViewController the VC view is added as a subview,
  // this means there's a reference to the VC view.
  // And, it's final for the VC view to exist even when the VC is gone.
  // So, to get rid of a UIViewController, need to 'unembed'.
//   TODO: Figure out whether the final willMove call is appropriate
  func unembed(_ viewController:UIViewController, inView view:UIView) {
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
    viewController.willMove(toParent: self)
  }
}
