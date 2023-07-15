//
//  TouchToPanGestureRecognizer.swift
//  woggle
//
//  Created by sparkes on 2023/07/15.
//
// This is very basic. It's nothing more than a PanGR which beings on touch rather than pan.

// I could make this cool though.
// 1. On first touch, anywhere on the tile is good.
// 2. On moving, things depend on speed.
// If fast, then need to go through the centre, but if slow then anywhere on the tile is good.
// Though, at the moment the touch pretty much corresponds to the letter as drawn in the tile, which also makes good sense and avoids doing additional calculations.

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
