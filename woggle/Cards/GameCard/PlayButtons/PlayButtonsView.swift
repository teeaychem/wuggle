//
//  PlayButtonsView.swift
//  woggle
//
//  Created by sparkes on 2023/06/28.
//

// TODO: A few things to implement.
// 1. For the newGameIcon, this should be animated in some way to draw attention when available.
// 2. All icons should have animations for initial paint.
// 3. Rework the iconIndent constant. Icons are drawn relative to a view, so ideally the indent is fixed relative to the view.
// 4. Along these lines, 

import UIKit

class PlayButtonsView: UIView {
  
  // Some size/position constants
  private let buttonSize: CGSize
  private let xPadding: CGFloat
  private let subButtonWidth: CGFloat
  private let yPadding: CGFloat
  private let iconIndent: CGFloat
  
  // Two subviews for playPause/Stop buttons
  let playPauseView: UIView
  private var playPauseLayer = CAShapeLayer()
  
  let stopView: UIView
  private var stopLayer = CAShapeLayer()
  
  init(viewData vD: CardViewData) {
    
    buttonSize = vD.playPauseStopSize
    xPadding = vD.gameBoardPadding * 0.5
    subButtonWidth = buttonSize.width - (xPadding * 2)
    yPadding = (buttonSize.height - (2 * (subButtonWidth))) / 3
    iconIndent = xPadding * 1.5
    
    playPauseView = UIView(frame: CGRect(x: xPadding, y: yPadding, width: subButtonWidth, height: subButtonWidth))
    stopView = UIView(frame: CGRect(x: xPadding, y: (2 *  yPadding) + (subButtonWidth), width: subButtonWidth, height: subButtonWidth))
    playPauseView.layer.cornerRadius = getCornerRadius(width: vD.width)
    stopView.layer.cornerRadius = getCornerRadius(width: vD.width)
    
    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize))
    
    addSubview(playPauseView)
    addSubview(stopView)
    
    setupSubView(view: playPauseView)
    setupSubView(view: stopView)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setupSubView (view: UIView) {
    view.backgroundColor = UIColor.lightGray
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 1
  }
  
  
  func removeStopIcon() {
    stopView.layer.sublayers?.removeAll()
  }
  
  
  func removePlayPauseIcon() {
    playPauseView.layer.sublayers?.removeAll()
  }
  
  
  func makeStopIcon(forView: UIView) -> CAShapeLayer {
    
    let stopIconLayer = CAShapeLayer()
    
    // This is a lot by hand, but it's fairly simple.
    // The icon is made by adding lines and arcs.
    // A line goes to the desired point, minus the desired corner radius.
    // To get the corner we then place a circle by adjusting the current point to accomodate the radius.
    
    // Ah, it's already available.
    // I wonder if it works the same way…
    // Not really, there's no need to explicitly add lines between arcs
    // See makeNewGameIcon
    
//    let stopIcon = UIBezierPath()
//    stopIcon.move(to: CGPoint(x: iconIndent + iconCornerRadius, y: iconIndent))
//    stopIcon.addLine(to: CGPoint(x: forView.frame.width - (iconIndent + iconCornerRadius), y: (iconIndent)))
//    stopIcon.addArc(withCenter: CGPoint(x: forView.frame.width - (iconIndent + iconCornerRadius), y: iconIndent + iconCornerRadius), radius: iconCornerRadius, startAngle: Double.pi * 1.5, endAngle: 0, clockwise: true)
//    stopIcon.addLine(to: CGPoint(x: forView.frame.width - (iconIndent), y: stopView.frame.height - (iconIndent + iconCornerRadius)))
//    stopIcon.addArc(withCenter: CGPoint(x: forView.frame.width - (iconIndent + iconCornerRadius), y: stopView.frame.height - (iconIndent + iconCornerRadius)), radius: iconCornerRadius, startAngle: 0, endAngle: Double.pi * 0.5, clockwise: true)
//    stopIcon.addLine(to: CGPoint(x: iconIndent + iconCornerRadius, y: forView.frame.height - iconIndent))
//    stopIcon.addArc(withCenter: CGPoint(x: (iconIndent + iconCornerRadius), y: stopView.frame.height - (iconIndent + iconCornerRadius)), radius: iconCornerRadius, startAngle: Double.pi * 0.5, endAngle: Double.pi, clockwise: true)
//    stopIcon.addLine(to: CGPoint(x: iconIndent, y: iconIndent + iconCornerRadius))
//    stopIcon.addArc(withCenter: CGPoint(x: (iconIndent + iconCornerRadius), y: (iconIndent + iconCornerRadius)), radius: iconCornerRadius, startAngle: Double.pi, endAngle: Double.pi * 1.5, clockwise: true)
    
    let stopIcon = UIBezierPath(roundedRect: CGRect(x: iconIndent, y: iconIndent, width: forView.frame.width - (2 * iconIndent), height: forView.frame.height - (2 * iconIndent)), cornerRadius: forView.layer.cornerRadius / 2)

    stopIcon.close()
    
    stopIconLayer.path = stopIcon.cgPath
    stopIconLayer.lineCap = .round
    stopIconLayer.strokeColor = interactiveStrokeColour.cgColor
    stopIconLayer.lineWidth = 1
    stopIconLayer.cornerRadius = 10
    stopIconLayer.fillColor = UIColor.gray.cgColor
    
    return stopIconLayer
  }
  
  
  func addStopIcon() {
    stopLayer = makeStopIcon(forView: stopView)
    stopView.layer.addSublayer(stopLayer)
  }
  
  
  func addPlayIcon() {
    playPauseLayer = makePlayIcon(forView: playPauseView)
    playPauseView.layer.addSublayer(playPauseLayer)
  }
  
  
  func addPauseIcon() {
    playPauseLayer = makePauseIcon(forView: playPauseView)
    playPauseView.layer.addSublayer(playPauseLayer)
  }
  
  
  func addNewGameIcon() {
    playPauseLayer = makeNewGameIcon(forView: playPauseView)
    playPauseView.layer.addSublayer(playPauseLayer)
  }
  
  
  func makePlayIcon(forView: UIView) -> CAShapeLayer {
    
    let playIconLayer = CAShapeLayer()
  
    // Basic idea, start in the top left.
    // Initial angle is pi.
    // Drawing an equalateral triangle, so each arc will be 2pi/3
    // Then, the next point is (r cos(angle), r sin(angle) offset by target point and radius.
    let iconCornerRadius = forView.layer.cornerRadius * 0.5
  
    let playIcon = UIBezierPath()
    playIcon.move(to: CGPoint(x: iconIndent, y: iconIndent + iconCornerRadius))
    
    let angleIncrement = (2/3) * Double.pi
    
    playIcon.addArc(withCenter: CGPoint(x: (iconIndent + iconCornerRadius), y: (iconIndent + iconCornerRadius)), radius: iconCornerRadius, startAngle: Double.pi, endAngle: Double.pi + angleIncrement, clockwise: true)
    playIcon.addArc(withCenter: CGPoint(x: forView.frame.width - (iconIndent + iconCornerRadius), y: forView.frame.height * 0.5), radius: iconCornerRadius, startAngle: Double.pi + angleIncrement, endAngle: Double.pi - angleIncrement, clockwise: true)
    playIcon.addArc(withCenter: CGPoint(x: iconIndent + iconCornerRadius, y: forView.frame.height - (iconIndent + iconCornerRadius)), radius: iconCornerRadius, startAngle: Double.pi - angleIncrement, endAngle: Double.pi, clockwise: true)
    playIcon.close()
    
    playIconLayer.path = playIcon.cgPath
    
    playIconLayer.lineCap = .round
    playIconLayer.strokeColor = interactiveStrokeColour.cgColor
    playIconLayer.lineWidth = 1
    playIconLayer.fillColor = UIColor.gray.cgColor
    
    return playIconLayer
  }
  
  
  func makePauseIcon(forView: UIView) -> CAShapeLayer {
    
    let iconCornerRadius = forView.layer.cornerRadius * 0.5
    let pauseIconLayer = CAShapeLayer()
    
    let pauseIconPath = CGMutablePath()
    let pauseSegmentWidth = (forView.frame.width - (3 * iconIndent)) / 2
    
    let pauseIconLeft = UIBezierPath(roundedRect: CGRect(x: iconIndent, y: iconIndent, width: pauseSegmentWidth, height: forView.frame.height - (2 * iconIndent)), cornerRadius: iconCornerRadius)
    let pauseIconRight = UIBezierPath(roundedRect: CGRect(x: forView.frame.width - (iconIndent + pauseSegmentWidth), y: iconIndent, width: pauseSegmentWidth, height: forView.frame.height - (2 * iconIndent)), cornerRadius: iconCornerRadius)

    
    pauseIconPath.addPath(pauseIconLeft.cgPath)
    pauseIconPath.addPath(pauseIconRight.cgPath)
    
    pauseIconLayer.path = pauseIconPath
    pauseIconLayer.lineCap = .round
    pauseIconLayer.strokeColor = interactiveStrokeColour.cgColor
    pauseIconLayer.lineWidth = 1
    pauseIconLayer.fillColor = UIColor.gray.cgColor
    
    return pauseIconLayer
  }
  
  
  func makeNewGameIcon(forView: UIView) -> CAShapeLayer {
    
    let iconCornerRadius = forView.layer.cornerRadius * 0.25
    let newGameIconLayer = CAShapeLayer()
    let iconArcIndent = iconIndent + iconCornerRadius
    
    let newGameIcon = UIBezierPath()
    newGameIcon.move(to: CGPoint(x: iconArcIndent, y: (forView.frame.height * 0.5 + iconCornerRadius)))
    newGameIcon.addArc(withCenter: CGPoint(x: iconArcIndent, y: forView.frame.height * 0.5), radius: iconCornerRadius, startAngle: Double.pi * 0.5, endAngle: Double.pi * 1.5 , clockwise: true)
    newGameIcon.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.5) - iconCornerRadius * 2, y: (forView.frame.height * 0.5) - iconCornerRadius * 2), radius: iconCornerRadius, startAngle: Double.pi * 0.5, endAngle: 0, clockwise: false)
    newGameIcon.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.5), y: iconArcIndent), radius: iconCornerRadius, startAngle: Double.pi, endAngle: 0, clockwise: true)
    newGameIcon.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.5 + iconCornerRadius * 2), y: (forView.frame.height * 0.5) - iconCornerRadius * 2), radius: iconCornerRadius, startAngle: Double.pi, endAngle: Double.pi * 0.5, clockwise: false)
    newGameIcon.addArc(withCenter: CGPoint(x: forView.frame.width - iconArcIndent, y: forView.frame.height * 0.5), radius: iconCornerRadius, startAngle: Double.pi * -0.5, endAngle: Double.pi * 0.5 , clockwise: true)
    newGameIcon.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.5 + iconCornerRadius * 2), y: (forView.frame.height * 0.5) + iconCornerRadius * 2), radius: iconCornerRadius, startAngle: Double.pi * -0.5, endAngle: -Double.pi, clockwise: false)
    newGameIcon.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.5), y: forView.frame.height - iconArcIndent), radius: iconCornerRadius, startAngle: 0, endAngle: Double.pi, clockwise: true)
    newGameIcon.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.5 - iconCornerRadius * 2), y: (forView.frame.height * 0.5) + iconCornerRadius * 2), radius: iconCornerRadius, startAngle: 0, endAngle: Double.pi * -0.5, clockwise: false)
    newGameIcon.close()
    
    newGameIconLayer.path = newGameIcon.cgPath
    newGameIconLayer.lineCap = .round
    newGameIconLayer.strokeColor = interactiveStrokeColour.cgColor
    newGameIconLayer.lineWidth = 1
    newGameIconLayer.fillColor = UIColor.gray.cgColor
    
    return newGameIconLayer
  }
  
}
