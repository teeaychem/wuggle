//
//  TouchToPanGestureRecognizer.swift
//  woggle
//
//  Created by sparkes on 2023/07/15.
//
// This is very basic. It's nothing more than a PanGR which beings on touch rather than pan.

import UIKit


class TouchToPanGestureRecognizer : UIGestureRecognizer {
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    if touches.count != 1 { state = .failed }
    state = .began
  }
  
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    if touches.count != 1 { state = .failed }
    state = .changed
  }
  
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    state = .ended
  }
  
}
