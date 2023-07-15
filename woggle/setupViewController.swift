//
//  setupViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/14.
//

import UIKit
import CoreData


class setupViewController: UIViewController {
  
  let sWidth: CGFloat
  let tileSize: CGSize
  let tileView: UIView
  let tileLayer = CAShapeLayer()
  
  var counter = 0
  var displayLinkOne: CADisplayLink?
  
  init() {
    
    sWidth = UIScreen.main.bounds.size.width
    tileSize = CGSize(width: sWidth * 0.25, height: sWidth * 0.25)
    tileView = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.size.width * 0.5 -  tileSize.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5 - tileSize.height * 0.5), size: tileSize))
    tileLayer.strokeColor = UIColor.white.cgColor
    
    tileView.layer.addSublayer(tileLayer)
    
    
    super.init(nibName: nil, bundle: nil)
    
    view.addSubview(tileView)
    displayLinkOne = CADisplayLink(target: self, selector: #selector(Counting))
    displayLinkOne!.add(to: .current, forMode: .common)
    print("making trie")
  }
  
  override func viewDidLoad() {
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    print("view did appear")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func Counting() {
    // As the timer for counting is tied to the refresh rate, updating the stopwatch is
    // done by calculating how much time has passed.
    if counter == 0 {
      tileLayer.path = randomStartRoundedUIBeizerPath(width: tileSize.width, height: tileSize.height, cornerRadius: tileSize.width * 0.25).cgPath
      let end = CABasicAnimation(keyPath: "strokeEnd")
      end.fromValue = 0
      end.toValue = 1
      CATransaction.begin()
      CATransaction.setAnimationDuration(2)
      tileLayer.add(end, forKey: end.keyPath)
      CATransaction.commit()
    }
    counter += 1
    if counter == 120 { counter = 0 }
    }
}
