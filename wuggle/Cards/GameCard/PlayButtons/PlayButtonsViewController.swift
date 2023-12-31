//
//  PlayButtonsViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/06/28.
//

import UIKit

class PlayButtonsViewController: UIViewController {

  private let playButtonsView: PlayButtonsView
  private let highlightLayer = CAShapeLayer()

  
  init(uiData uiD: UIData) {
    
    playButtonsView = PlayButtonsView(uiData: uiD)
    highlightLayer.strokeColor = uiD.userInteractionColour.cgColor
   
    super.init(nibName: nil, bundle: nil)
    
    view.layer.cornerRadius = getCornerRadius(width: uiD.cardSize.width)
    view.backgroundColor = uiD.colourD
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    self.view.addSubview(playButtonsView)
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = playButtonsView.frame.size
  }
  
  
  func paintPlayIcon() {
    playButtonsView.removePlayPauseIcon()
    playButtonsView.addPlayIcon()
  }
  
  
  func paintPauseIcon() {
    playButtonsView.removePlayPauseIcon()
    playButtonsView.addPauseIcon()
  }
  
  
  func displayNewGameIcon() {
    playButtonsView.removePlayPauseIcon()
    playButtonsView.addNewGameIcon()
  }
  
  
  func rotatePlayPauseIcon(percent p: Double) {
    guard p <= 1 else { return }
    
    playButtonsView.rotatePlayPauseLayer(percent: p)
  }
  
  
  func paintStopIcon() {
    playButtonsView.removeStopIcon()
    playButtonsView.addStopIcon()
  }
  
  
  func hideStopIcon() {
    playButtonsView.removeStopIcon()
  }
  
  
  func animateHighlight() {
    
    let borderPath = UIBezierPath()
    borderPath.move(to: CGPoint(x: view.layer.frame.width * 0.5,  y: 0))
    borderPath.addArc(withCenter: CGPoint(x: view.layer.frame.width - view.layer.cornerRadius, y: view.layer.cornerRadius), radius: view.layer.cornerRadius, startAngle: -Double.pi * 0.5, endAngle: 0, clockwise: true)
    borderPath.addArc(withCenter: CGPoint(x: view.layer.frame.width - view.layer.cornerRadius, y: view.layer.frame.height - view.layer.cornerRadius), radius: view.layer.cornerRadius, startAngle: 0, endAngle: Double.pi * 0.5, clockwise: true)
    borderPath.addArc(withCenter: CGPoint(x: view.layer.cornerRadius, y: view.layer.frame.height - view.layer.cornerRadius), radius: view.layer.cornerRadius, startAngle: Double.pi * 0.5, endAngle: Double.pi, clockwise: true)
    borderPath.addArc(withCenter: CGPoint(x: view.layer.cornerRadius, y: view.layer.cornerRadius), radius: view.layer.cornerRadius, startAngle: Double.pi, endAngle: Double.pi * 1.5, clockwise: true)
    borderPath.close()

    borderPath.lineWidth = 4
    
    highlightLayer.path = borderPath.cgPath
    highlightLayer.fillColor = UIColor.clear.cgColor
    
    view.layer.addSublayer(highlightLayer)
    
    let end = CABasicAnimation(keyPath: "strokeEnd")
    end.fromValue = 0
    end.toValue = 1
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.25)
    
    highlightLayer.add(end, forKey: end.keyPath)

    CATransaction.commit()
  }
  
  
  func removeHighlight() {
    highlightLayer.removeFromSuperlayer()
  }
  
  
  func playPauseAddGesture(gesture: UIGestureRecognizer) {
    playButtonsView.playPauseView.addGestureRecognizer(gesture)
  }
  
  func playPauseRemoveGesture(gesture: UIGestureRecognizer) {
    playButtonsView.playPauseView.removeGestureRecognizer(gesture)
  }
  
  
  func stopAddGesture(gesture: UIGestureRecognizer) {
    playButtonsView.stopView.addGestureRecognizer(gesture)
  }
  
  
  func stopRemoveGesture(gesture: UIGestureRecognizer) {
    playButtonsView.stopView.removeGestureRecognizer(gesture)
  }
  
  
  func removeAllGestureRecognizers() {
    if playButtonsView.playPauseView.gestureRecognizers != nil {
      for gr in playButtonsView.playPauseView.gestureRecognizers! {
        playButtonsView.playPauseView.removeGestureRecognizer(gr)
      }
    }
    if playButtonsView.stopView.gestureRecognizers != nil {
      for gr in playButtonsView.stopView.gestureRecognizers! {
        playButtonsView.stopView.removeGestureRecognizer(gr)
      }
    }
  }
  
}
