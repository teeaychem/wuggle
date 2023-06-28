//
//  StopwatchView.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchView: UIView {
  
  private let faceLayer = CAShapeLayer()
  private let secondsLayer = CAShapeLayer()
  private let restartArrowOneLayer = CAShapeLayer()
  private let restartArrowTwoLayer = CAShapeLayer()
  
  private let centerCFLoat: CGFloat
  private let lineWidth: CGFloat
  private let watchRadius: CGFloat
  
  private let secondsLength: CGFloat
  
  private var secondsAngle = 1.5 * Double.pi
  
  init(size s: CGFloat) {
    
    lineWidth = s * 0.05
    centerCFLoat = s * 0.5
    watchRadius = s * 0.4
    secondsLength = (watchRadius * 0.9) - (2 * lineWidth)
    
    super.init(frame: CGRect(x: 0, y: 0, width: s, height: s))
    
    layer.addSublayer(faceLayer)
    detailFaceLayer(fLayer: faceLayer)
    
    self.backgroundColor = UIColor.darkGray
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

  
  func addSeconds() {
    drawSeconds(angle: secondsAngle)
  }
  
  func incrementSeconds(updateAngleIncrement: Double) {
    secondsAngle = (secondsAngle - updateAngleIncrement) //.truncatingRemainder(dividingBy: 2 * Double.pi)
    // There's no need to truncate.
    drawSeconds(angle: secondsAngle)
  }
}


// MARK: Functions to modify layers
extension StopwatchView {
  
  
  func detailFaceLayer(fLayer: CAShapeLayer) {
    
    let facePath = UIBezierPath(
      arcCenter: CGPoint(x: centerCFLoat, y: centerCFLoat),
      radius: CGFloat(watchRadius - (lineWidth * 0.5)),
      startAngle: CGFloat(-(Double.pi / 2)),
      endAngle: CGFloat(3 * (Double.pi / 2)),
      clockwise: true)
    
    fLayer.path = facePath.cgPath
    fLayer.fillColor = UIColor.clear.cgColor
    fLayer.strokeColor = interactiveStrokeColour.cgColor
    fLayer.lineWidth = lineWidth
    fLayer.lineDashPattern = [NSNumber(value: (Double.pi * 2 * Double(watchRadius)/6)), NSNumber(value: Double(lineWidth)*2)]
    fLayer.lineCap = .round
  }
  
  
  func drawSeconds(angle: Double) {
    let secondsHand = UIBezierPath()
    secondsHand.move(to: CGPoint(x: centerCFLoat, y: centerCFLoat))
    secondsHand.addLine(to: CGPoint(x: centerCFLoat + (secondsLength * CGFloat(cos(angle))),
                                    y: centerCFLoat + (secondsLength * CGFloat(sin(angle)))
    ))
    secondsLayer.lineCap = .round
    secondsLayer.path = secondsHand.cgPath
    secondsLayer.strokeColor = interactiveStrokeColour.cgColor
    secondsLayer.lineWidth = lineWidth
    
    faceLayer.addSublayer(secondsLayer)
  }
  
  
  func addRestartArrows() {
    
    if layer.sublayers?.count ?? 0 > 0 {
      for lay in layer.sublayers! {
        lay.removeAllAnimations()
      }
    }
    
    let arrowColour = UIColor.lightGray.cgColor
    
    restartArrowOneLayer.path =  resetArrowPath(yPos: centerCFLoat).cgPath
    restartArrowOneLayer.fillColor = UIColor.clear.cgColor
    restartArrowOneLayer.strokeColor = arrowColour
    restartArrowOneLayer.lineWidth = lineWidth
    
    let restartTwoArrow = resetArrowPath(yPos: centerCFLoat)

    restartTwoArrow.apply(CGAffineTransform(translationX: centerCFLoat, y: centerCFLoat).inverted())
    restartTwoArrow.apply(CGAffineTransform(rotationAngle: CGFloat(Double.pi)))
    restartTwoArrow.apply(CGAffineTransform(translationX: centerCFLoat, y: centerCFLoat))

    restartArrowTwoLayer.fillColor = UIColor.clear.cgColor
    restartArrowTwoLayer.strokeColor = arrowColour
    restartArrowTwoLayer.lineWidth = lineWidth

    restartArrowTwoLayer.path =  restartTwoArrow.cgPath
//
    let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeAnimation.fromValue = 0.0
    strokeAnimation.toValue = 1.0
    strokeAnimation.duration = defaultAnimationDuration
    strokeAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0.5, 1)
//
    let colourAnimation = CABasicAnimation(keyPath: "opacity")
    colourAnimation.fromValue = 0.5
    colourAnimation.toValue = 1
    colourAnimation.duration = defaultAnimationDuration
    colourAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0, 0.5, 1)
//
    restartArrowOneLayer.add(strokeAnimation, forKey: strokeAnimation.keyPath)
    restartArrowOneLayer.add(colourAnimation, forKey: colourAnimation.keyPath)
    restartArrowTwoLayer.add(strokeAnimation, forKey: strokeAnimation.keyPath)
    restartArrowTwoLayer.add(colourAnimation, forKey: colourAnimation.keyPath)
    
    faceLayer.addSublayer(restartArrowOneLayer)
    faceLayer.addSublayer(restartArrowTwoLayer)
//
//    layer.sublayers?.insert(restartArrowOneLayer, at: 0)
//    layer.sublayers?.insert(restartArrowTwoLayer, at: 0)
  }
  
}


//MARK: Functions to create layers
extension StopwatchView {
  
  
  private func resetArrowPath(yPos: CGFloat) -> UIBezierPath {
    // This is complex, as we want the arrow end to be curved in a natural way.
    
    let restartInset = lineWidth * 3
    let resetRadius = watchRadius - restartInset
    let resetEndAngle = CGFloat.pi * 0.8
    
    let miniRadius = restartInset
    
    let circleTwoPoint = CGPoint(x: centerCFLoat + ((watchRadius - restartInset) * CGFloat(cos(resetEndAngle))),
                                 y: yPos + ((watchRadius - restartInset) * CGFloat(sin(resetEndAngle))))
    
    let intersectionPoints = getIntersection(circleOne: CGPoint(x: centerCFLoat, y: centerCFLoat), radiusOne: resetRadius, circleTwo: circleTwoPoint, radiusTwo: miniRadius)
    
    let test = intersectionPoints[0]
    
    let intersectionAngle = atan2(test.y - circleTwoPoint.y, test.x - circleTwoPoint.x)
    
    
    let arrowCord = 2 * lineWidth
    let arrowStartAngle = intersectionAngle - CGFloat.pi/8 // + CGFloat.pi/8
    let arrowEndAngle = intersectionAngle + CGFloat.pi/8
    
    let arrowMeetPoint = CGPoint(x: centerCFLoat + ((watchRadius - restartInset) * CGFloat(cos(resetEndAngle))),
                                 y: yPos + ((watchRadius - restartInset) * CGFloat(sin(resetEndAngle))))
    
    let arrowFirstPoint = CGPoint(x: arrowMeetPoint.x + arrowCord * CGFloat(cos(arrowStartAngle)),
                                  y: arrowMeetPoint.y + arrowCord * CGFloat(sin(arrowStartAngle)))
    
    let arrowSecondPoint = CGPoint(x: arrowMeetPoint.x + arrowCord * CGFloat(cos(arrowEndAngle)),
                                   y: arrowMeetPoint.y + arrowCord * CGFloat(sin(arrowEndAngle)))
    
    let arrowBasePoint = CGPoint(x: centerCFLoat + ((watchRadius - restartInset) * CGFloat(cos(resetEndAngle))),
                                 y: yPos + ((watchRadius - restartInset) * CGFloat(sin(resetEndAngle))))
    
    
    let restartLine = UIBezierPath(
      arcCenter: CGPoint(x: centerCFLoat, y: yPos),
      radius: CGFloat(watchRadius - restartInset),
      startAngle: CGFloat(0),
      endAngle:CGFloat(resetEndAngle),
      clockwise: true)
    
    let restartArrow = UIBezierPath()
    
    restartArrow.move(to: arrowFirstPoint )
    restartArrow.addLine(to: arrowMeetPoint)
    restartArrow.addLine(to: arrowSecondPoint)
    restartArrow.addArc(withCenter: arrowBasePoint, radius: arrowCord, startAngle: arrowEndAngle, endAngle: arrowStartAngle, clockwise: false)
    restartArrow.close()
    
    restartLine.append(restartArrow)
    
    return restartLine
  }
  
}


//MARK: Misc helper functions
extension StopwatchView {
  
  
  func getIntersection(circleOne cO: CGPoint, radiusOne rO: CGFloat, circleTwo cT: CGPoint, radiusTwo rT: CGFloat) -> [CGPoint] {
    // Help from https://math.stackexchange.com/questions/256100/how-can-i-find-the-points-at-which-two-circles-intersect
    // and
    // https://gist.github.com/jupdike/bfe5eb23d1c395d8a0a1a4ddd94882ac
    
    
    let d = sqrt(pow(cO.x - cT.x, 2) + pow(cO.y - cT.y, 2))
    
    if d > rO + rT || d < abs(rT - rO) || (d == 0 && rO == rT) {
      return []
    } else {
      
      let d2 = pow(d,2)
      let d4 = pow(d,4)
      
      let a = (pow(rO,2) - pow(rT,2)) / (2*d2)
      let r1r2 = (pow(rO,2) - pow(rT,2))
      let c = sqrt((2*(pow(rO,2) + pow(rT,2))) / d2) - ((pow(r1r2,2) / d4) - 1)
      
      let fx = (cO.x + cT.x) / 2 + a * (cT.x - cO.x)
      let gx = c * (cT.y - cO.y) / 2
      
      let ix1 = fx + gx
      let ix2 = fx - gx
      
      let fy = (cO.y + cT.y) / 2 + a * (cT.y - cO.y)
      let gy = c * (cO.x - cT.x) / 2
      
      let iy1 = fy + gy
      let iy2 = fy - gy
      
      return [CGPoint(x: ix1, y: iy1), CGPoint(x: ix2, y: iy2)]
    }
  }
  
  
}
