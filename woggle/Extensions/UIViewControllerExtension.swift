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
  // Add the controller view as a subview
  // Add the controller
  // State the move is completed.
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
